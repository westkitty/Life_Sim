class_name ParitySystemHub
extends Node

signal birth_ready(mother_id: String, father_id: String)
signal opportunity_completed(sim_id: String, household_id: String, reward: int, title: String)
signal service_arrived(service_id: String, household_id: String, request: Dictionary)

var build_grid := BuildGridSystem.new()
var routing := RoutingSystem.new()
var trait_tuning := TraitTuningSystem.new()
var socials := SocialSystem.new()
var genealogy := GenealogySystem.new()
var genetics := GeneticsSystem.new()
var pregnancy := PregnancySystem.new()
var school := SchoolSystem.new()
var bills := BillSystem.new()
var services := ServiceSystem.new()
var opportunities := OpportunitySystem.new()
var collecting := CollectingSystem.new()
var gardening := GardeningSystem.new()
var fishing := FishingSystem.new()
var cooking := CookingSystem.new()
var parties := PartySystem.new()
var death := DeathSystem.new()
var pets := PetSystem.new()
var performers := PerformerSystem.new()
var expansions := ExpansionRuntimeSystem.new()

func _ready() -> void:
	for system in [build_grid, routing, trait_tuning, socials, genealogy, genetics, pregnancy, school, bills, services, opportunities, collecting, gardening, fishing, cooking, parties, death, pets, performers, expansions]:
		add_child(system)
	socials.configure(trait_tuning)

func configure_world(lot_definitions: Array, objects: Array, cell_size := 1.0, structure_blockers: Array = []) -> void:
	build_grid.configure_lots(lot_definitions, cell_size)
	build_grid.clear_occupancy()
	for object in objects:
		if object is InteractableObject and is_instance_valid(object):
			object.grid_size = build_grid.grid_size
			build_grid.register_object(object.object_instance_id, object.global_position, object.footprint, object.rotation.y)
	routing.configure(build_grid)
	routing.set_structure_blockers(structure_blockers)
	routing.rebuild()

func register_object(object: InteractableObject) -> bool:
	if object == null:
		return false
	var ok := build_grid.register_object(object.object_instance_id, object.global_position, object.footprint, object.rotation.y)
	routing.mark_dirty()
	return ok

func unregister_object(object_id: String) -> void:
	build_grid.unregister_object(object_id)
	routing.mark_dirty()

## Resolves an interaction to a reachable access slot. Returns an empty
## dictionary when no candidate slot can be routed to, so callers fail safely
## instead of walking a Sim through blocked geometry.
func prepare_interaction_route(sim: SimAgent, interaction: Dictionary) -> Dictionary:
	if sim == null or interaction.is_empty():
		return {}
	var target: Variant = interaction.get("target_position", sim.global_position)
	if not target is Vector3:
		return interaction
	var candidates: Array[Vector3] = []
	for value in Array(interaction.get("slot_candidates", [])):
		if value is Vector3:
			candidates.append(value)
	if not candidates.has(Vector3(target)):
		candidates.push_front(Vector3(target))
	candidates.sort_custom(func(a: Vector3, b: Vector3) -> bool:
		return sim.global_position.distance_squared_to(a) < sim.global_position.distance_squared_to(b))
	for candidate in candidates:
		var route := routing.route(sim.global_position, candidate)
		if route.is_empty():
			continue
		var prepared := interaction.duplicate(true)
		prepared.erase("slot_candidates")
		prepared["target_position"] = candidate
		prepared["route_points"] = route
		return prepared
	return {}

func tick_minute(sims: Array, total_minutes: int, day_index: int, hour: int, weather: WeatherSystem) -> void:
	pregnancy.tick(1.0)
	pets.tick(1.0)
	for due in pregnancy.collect_due():
		birth_ready.emit(String(due.get("mother_id", "")), String(due.get("father_id", "")))
	var weekday := day_index % 7
	for sim in sims:
		if not sim is SimAgent or not is_instance_valid(sim):
			continue
		school.tick(sim.profile, hour, weekday, 1.0)
		var exposure := expansions.record_weather_exposure(sim.profile.sim_id, weather.temperature_c, 1.0)
		if exposure >= 80.0 and total_minutes % 30 == 0:
			EventBus.notify("Temperature exposure", "%s needs shelter from extreme weather." % sim.profile.first_name)
	for arrived in services.tick(1.0):
		service_arrived.emit(String(arrived.get("service_id", "")), String(arrived.get("household_id", "")), arrived)
	for ended in parties.tick(1.0):
		EventBus.notify("Party ended", "Party outcome: %s." % String(ended.get("outcome", "complete")).capitalize())

func advance_day(day_index: int, households: Dictionary, object_count: int, weather: WeatherSystem) -> void:
	bills.assess_day(day_index, households, object_count)
	gardening.tick_day()
	school.advance_day()
	expansions.advance_day(day_index, weather)

func record_interaction(sim: SimAgent, interaction: Dictionary, inventory: InventorySystem) -> Dictionary:
	var pack_result := expansions.record_interaction(sim.profile, interaction)
	var completed_opportunity := opportunities.record_interaction(sim.profile, interaction)
	var special := String(interaction.get("special", ""))
	match special:
		"pet_feed":
			var pet_id := String(interaction.get("pet_id", ""))
			if pet_id.is_empty() and not pets.pets.is_empty(): pet_id = String(pets.pets.keys()[0])
			pets.interact(pet_id, "feed_pet", sim.profile.sim_id)
		"pet_play":
			var pet_id := String(interaction.get("pet_id", ""))
			if pet_id.is_empty() and not pets.pets.is_empty(): pet_id = String(pets.pets.keys()[0])
			pets.interact(pet_id, "play_pet", sim.profile.sim_id)
		"pet_train":
			var pet_id := String(interaction.get("pet_id", ""))
			if pet_id.is_empty() and not pets.pets.is_empty(): pet_id = String(pets.pets.keys()[0])
			pets.interact(pet_id, "train_pet", sim.profile.sim_id)
		"performance": performers.record_performance(sim.profile.sim_id, String(interaction.get("id", "performance")))
		"collect_rock":
			var item := collecting.collect(sim.profile.sim_id, "quartz")
			if not item.is_empty(): inventory.add_personal(sim.profile.sim_id, item)
		"go_fishing":
			var fish := fishing.catch_fish(sim.profile)
			if not fish.is_empty(): inventory.add_personal(sim.profile.sim_id, fish)
		"cook_recipe":
			var meal := cooking.cook(sim.profile, String(interaction.get("recipe_id", "autumn_salad")), 4)
			if not meal.is_empty(): inventory.add_personal(sim.profile.sim_id, meal)
		"garden_plant":
			gardening.plant(sim.profile.sim_id, String(interaction.get("species", "tomato")), sim.global_position)
		"do_homework":
			school.complete_homework(sim.profile, float(interaction.get("homework_amount", 30.0)))
	if not completed_opportunity.is_empty():
		EventBus.notify("Opportunity complete", "%s completed %s." % [sim.profile.first_name, String(completed_opportunity.get("title", "an opportunity"))])
		# The payout is emitted exactly once: OpportunitySystem erases the active
		# entry on completion, so a repeated interaction cannot re-trigger it.
		opportunity_completed.emit(
			sim.profile.sim_id,
			sim.profile.household_id,
			int(completed_opportunity.get("reward", 0)),
			String(completed_opportunity.get("title", "Opportunity"))
		)
	return pack_result

func serialize() -> Dictionary:
	return {
		"genealogy": genealogy.serialize(), "pregnancy": pregnancy.serialize(), "school": school.serialize(),
		"bills": bills.serialize(), "services": services.serialize(), "opportunities": opportunities.serialize(),
		"collecting": collecting.serialize(), "gardening": gardening.serialize(), "fishing": fishing.serialize(),
		"cooking": cooking.serialize(), "parties": parties.serialize(), "death": death.serialize(),
		"pets": pets.serialize(), "performers": performers.serialize(),
		"expansions": expansions.serialize(),
	}

func deserialize(data: Dictionary) -> void:
	genealogy.deserialize(Dictionary(data.get("genealogy", {})))
	pregnancy.deserialize(Dictionary(data.get("pregnancy", {})))
	school.deserialize(Dictionary(data.get("school", {})))
	bills.deserialize(Dictionary(data.get("bills", {})))
	services.deserialize(Dictionary(data.get("services", {})))
	opportunities.deserialize(Dictionary(data.get("opportunities", {})))
	collecting.deserialize(Dictionary(data.get("collecting", {})))
	gardening.deserialize(Dictionary(data.get("gardening", {})))
	fishing.deserialize(Dictionary(data.get("fishing", {})))
	cooking.deserialize(Dictionary(data.get("cooking", {})))
	parties.deserialize(Dictionary(data.get("parties", {})))
	death.deserialize(Dictionary(data.get("death", {})))
	pets.deserialize(Dictionary(data.get("pets", {})))
	performers.deserialize(Dictionary(data.get("performers", {})))
	expansions.deserialize(Dictionary(data.get("expansions", {})))
