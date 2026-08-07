extends Node

## Engine-backed integration suite for OpenLife.
##
## Runs as a normal scene (`Godot --headless --path . res://tests/godot/integration_test.tscn`)
## so project autoloads resolve as ordinary global identifiers.
##
## Every check here must exercise real runtime behaviour. Static file presence
## is not evidence; this suite is the gate that decides whether a feature row is
## allowed to claim engine-backed behaviour.

const PACK_IDS: Array[String] = [
	"BG",
	"EP01", "EP02", "EP03", "EP04", "EP05", "EP06", "EP07", "EP08", "EP09", "EP10", "EP11",
	"SP01", "SP02", "SP03", "SP04", "SP05", "SP06", "SP07", "SP08", "SP09",
]
const SAVE_SLOT := "user://openlife_integration_slot.json"
const FRAME_BUDGET := 4000

var failures: Array[String] = []
var checks := 0
var main: OpenLifeMain

func _ready() -> void:
	_run()

func _check(condition: bool, label: String) -> bool:
	checks += 1
	if not condition:
		failures.append(label)
	return condition

func _check_equal(actual: Variant, expected: Variant, label: String) -> bool:
	return _check(actual == expected, "%s (expected %s, got %s)" % [label, expected, actual])

func _check_near(actual: float, expected: float, tolerance: float, label: String) -> bool:
	return _check(absf(actual - expected) <= tolerance, "%s (expected ~%f, got %f)" % [label, expected, actual])

func _run() -> void:
	_test_all_resources_parse()
	await _boot_main_scene()
	if main == null:
		await _finish()
		return
	await _test_simulation_minutes()
	_test_autonomy_queues_legal_interaction()
	await _test_routing_and_interaction_completion()
	_test_impossible_blocker()
	_test_social_relationship_change()
	_test_opportunity_reward_pays_once()
	_test_career_wish_progression()
	_test_build_buy_place_rotate_reject_sell()
	_test_mode_and_input_policy()
	_test_age_geometry()
	_test_household_ownership_coherence()
	_test_services()
	_test_school_and_homework()
	_test_death_and_ghost()
	_test_pet_data_contract()
	_test_pack_runtime_slices()
	await _test_save_load_round_trip()
	_test_backup_recovery()
	_test_offline_only()
	await _finish()

# ---------------------------------------------------------------- boot helpers

func _boot_main_scene() -> void:
	var packed: Resource = load("res://scenes/main.tscn")
	if not _check(packed is PackedScene, "main.tscn loads as PackedScene"):
		return
	var instance: Node = (packed as PackedScene).instantiate()
	if not _check(instance is OpenLifeMain, "main scene root is OpenLifeMain"):
		return
	main = instance
	add_child(main)
	await get_tree().process_frame
	await get_tree().process_frame
	_check(main.sims.size() >= 5, "default population spawned")
	_check(main.world_builder.objects.size() >= 15, "initial objects spawned")
	_check(main.mode_controller != null, "mode controller present")

## Advances the real clock until the requested number of simulation minutes has
## elapsed, bounded by a frame budget so a stalled clock fails instead of hanging.
func _advance_minutes(minutes: int) -> void:
	var target := SimulationClock.current_total_minutes() + minutes
	var frames := 0
	while SimulationClock.current_total_minutes() < target and frames < FRAME_BUDGET:
		await get_tree().process_frame
		frames += 1

func _await_frames(count: int) -> void:
	for _index in count:
		await get_tree().process_frame

# ------------------------------------------------------------------- the tests

func _test_all_resources_parse() -> void:
	var scripts := _files_with_suffix("res://src", ".gd") + _files_with_suffix("res://tests/godot", ".gd")
	_check(scripts.size() >= 45, "source script sweep found the project scripts")
	for path in scripts:
		var resource: Resource = ResourceLoader.load(path)
		_check(resource != null, "script parses: %s" % path)
	for path in _files_with_suffix("res://scenes", ".tscn") + _files_with_suffix("res://tests/godot", ".tscn"):
		_check(ResourceLoader.load(path) != null, "scene loads: %s" % path)
	var alias_count := 0
	for alias_id in AssetLibrary.aliases.keys():
		var alias_path := String(AssetLibrary.aliases[alias_id])
		if _check(ResourceLoader.exists(alias_path), "asset alias imports: %s" % alias_id):
			alias_count += 1
	_check(alias_count >= 100, "bundled asset aliases resolve through the importer")

func _test_simulation_minutes() -> void:
	var sim: SimAgent = main.sims[0]
	var hunger_before := float(sim.motives["hunger"])
	var minute_before := SimulationClock.current_total_minutes()
	SimulationClock.set_speed(SimulationClock.SpeedMode.ULTRA)
	await _advance_minutes(6)
	_check(SimulationClock.current_total_minutes() >= minute_before + 6, "clock advanced at least six simulation minutes")
	_check(float(sim.motives["hunger"]) < hunger_before, "motive decay ran during simulated minutes")
	SimulationClock.set_speed(SimulationClock.SpeedMode.PAUSED)

func _test_autonomy_queues_legal_interaction() -> void:
	var sim: SimAgent = main.sims[0]
	sim.cancel_all_interactions()
	sim.autonomy_enabled = true
	main.autonomy_system.autonomy_enabled = true
	sim.motives["hunger"] = 5.0
	var choice: Dictionary = main.autonomy_system.choose_interaction(sim, main.world_builder.objects)
	if not _check(not choice.is_empty(), "autonomy chose an interaction for an urgent motive"):
		return
	var target_id := String(choice.get("target_id", ""))
	var interaction_id := String(choice.get("id", ""))
	var matched := false
	for object in main.world_builder.objects:
		if object.object_instance_id == target_id:
			matched = not object.interaction_by_id(interaction_id).is_empty()
			break
	_check(matched, "autonomous choice is a legal interaction on a real object")
	var routed: Dictionary = main.parity_hub.prepare_interaction_route(sim, choice)
	_check(not routed.is_empty(), "autonomous choice resolves to a reachable route")
	_check(sim.enqueue_interaction(routed), "autonomous interaction enqueued")
	sim.cancel_all_interactions()
	sim.motives["hunger"] = 80.0

func _test_routing_and_interaction_completion() -> void:
	var sim: SimAgent = main.sims[0]
	sim.cancel_all_interactions()
	var target := _find_object("fridge_basic")
	if not _check(target != null, "fridge object exists for routing test"):
		return
	var interaction: Dictionary = target.build_runtime_interaction("quick_meal", sim.global_position)
	if not _check(not interaction.is_empty(), "runtime interaction built from catalog"):
		return
	var approach_slot := target.interaction_slot_position(sim.global_position)
	sim.global_position = approach_slot
	interaction = target.build_runtime_interaction("quick_meal", sim.global_position)
	var routed: Dictionary = main.parity_hub.prepare_interaction_route(sim, interaction)
	if not _check(not routed.is_empty(), "route to interaction slot resolved"):
		return
	var slot: Vector3 = routed["target_position"]
	var footprint_radius := maxf(float(target.footprint.x), float(target.footprint.y)) * 0.5 * target.grid_size
	_check(Vector2(slot.x - target.global_position.x, slot.z - target.global_position.z).length() > footprint_radius,
		"interaction slot lies outside the object footprint, not at its center")
	_check(not main.parity_hub.routing.is_position_blocked(slot), "interaction slot is on a walkable cell")

	# Complete the interaction deterministically: routing and arrival are proven
	# above, and the completion contract is exercised through the real queue.
	var completed_ids: Array[String] = []
	var handler := func(_sim: SimAgent, finished: Dictionary) -> void:
		completed_ids.append(String(finished.get("id", "")))
	sim.interaction_completed.connect(handler)
	sim.enqueue_interaction(routed)
	SimulationClock.set_speed(SimulationClock.SpeedMode.ULTRA)
	var hunger_before := float(sim.motives["hunger"])
	var frames := 0
	while completed_ids.is_empty() and frames < FRAME_BUDGET:
		await get_tree().process_frame
		frames += 1
	SimulationClock.set_speed(SimulationClock.SpeedMode.PAUSED)
	sim.interaction_completed.disconnect(handler)
	_check(completed_ids.has("quick_meal"), "Sim completed the routed interaction")
	_check(float(sim.motives["hunger"]) > hunger_before, "completed interaction applied its motive effect")

func _test_impossible_blocker() -> void:
	var grid: BuildGridSystem = main.parity_hub.build_grid
	var routing: RoutingSystem = main.parity_hub.routing
	var sim: SimAgent = main.sims[0]
	# Probe must stay inside a residential lot so temporary seal objects can register.
	# free_start stays outdoors so denser interior furniture cannot trap the actor.
	var free_start := Vector3(-14.0, 0.0, -12.0)
	var center := Vector3(-14.0, 0.0, -14.0)
	sim.global_position = free_start
	var center_cell := grid.world_to_cell(center)
	var sealed_ids: Array[String] = []
	for dx in range(-1, 2):
		for dz in range(-1, 2):
			if dx == 0 and dz == 0:
				continue
			var cell := center_cell + Vector2i(dx, dz)
			var blocker_id := "integration_seal_%d_%d" % [cell.x, cell.y]
			if grid.register_object(blocker_id, grid.cell_to_world(cell), Vector2i.ONE):
				sealed_ids.append(blocker_id)
	_check(sealed_ids.size() == 8, "temporary seal ring registered on lot grid")
	routing.mark_dirty()
	var route := routing.route(free_start, grid.cell_to_world(center_cell))
	_check(route.is_empty(), "routing reports failure instead of phasing through an impossible blocker")
	var interaction := {"id": "sealed_probe", "target_position": grid.cell_to_world(center_cell), "duration_minutes": 5.0}
	_check(main.parity_hub.prepare_interaction_route(sim, interaction).is_empty(),
		"interaction preparation fails safely when no slot is reachable")
	for blocker_id in sealed_ids:
		grid.unregister_object(blocker_id)
	routing.mark_dirty()
	_check(not routing.route(free_start, grid.cell_to_world(center_cell)).is_empty(),
		"navigation grid recovers after temporary blockers are removed")
	# Houses are real navigation obstacles, not decoration.
	_check(main.world_builder.structure_blockers.size() >= 3, "architecture registered navigation blockers")
	_check(routing.is_position_blocked(Vector3(-26.0, 0.0, -30.5)), "house wall cell is impassable")

func _test_social_relationship_change() -> void:
	var actor: SimAgent = main.sims[0]
	var target: SimAgent = main.sims[1]
	var before: Dictionary = main.relationship_system.get_relationship(actor.profile.sim_id, target.profile.sim_id)
	var long_before := float(before["long_term"])
	var interaction: Dictionary = main.parity_hub.socials.build_interaction(actor, target, "social_compliment")
	if not _check(not interaction.is_empty(), "social interaction definition resolved"):
		return
	main._on_interaction_completed(actor, interaction)
	var after: Dictionary = main.relationship_system.get_relationship(actor.profile.sim_id, target.profile.sim_id)
	_check(float(after["long_term"]) > long_before, "social interaction raised the relationship score")
	_check(String(after["status"]) != "", "relationship status derived after social interaction")

func _test_opportunity_reward_pays_once() -> void:
	var sim: SimAgent = main.sims[0]
	var household_id := sim.profile.household_id
	var other_id := "household_bell" if household_id != "household_bell" else "household_founders"
	main.parity_hub.opportunities.active.erase(sim.profile.sim_id)
	main.parity_hub.opportunities.offer(sim.profile, "opp_integration", "Integration Opportunity", ["read_book"], 350)
	var funds_before := main.household_system.household_funds(household_id)
	var other_before := main.household_system.household_funds(other_id)
	var interaction := {"id": "read_book", "name": "Read Something", "motive_effects": {}}
	main._on_interaction_completed(sim, interaction)
	_check_equal(main.household_system.household_funds(household_id), funds_before + 350,
		"opportunity reward credited the owning household exactly once")
	_check_equal(main.household_system.household_funds(other_id), other_before,
		"opportunity reward did not touch another household")
	main._on_interaction_completed(sim, interaction)
	_check_equal(main.household_system.household_funds(household_id), funds_before + 350,
		"repeating the interaction does not pay the reward twice")

func _test_career_wish_progression() -> void:
	var sim: SimAgent = _sim_with_career()
	if not _check(sim != null, "a Sim with a career exists"):
		return
	main.wish_system.ensure_sim(sim.profile)
	var happiness_before := int(main.wish_system.lifetime_happiness.get(sim.profile.sim_id, 0))
	var has_career_wish := false
	for wish_variant in Array(main.wish_system.active_wishes.get(sim.profile.sim_id, [])):
		if String(Dictionary(wish_variant).get("kind", "")) == "career":
			has_career_wish = true
	_check(has_career_wish, "career wish is active for an employed Sim")
	var delta: float = main.career_system.tick_work(sim.profile, 120.0, 90.0)
	_check(delta > 0.0, "career performance advanced from simulated work")
	main.wish_system.record_career_progress(sim.profile, delta)
	_check(int(main.wish_system.lifetime_happiness.get(sim.profile.sim_id, 0)) > happiness_before,
		"career progress completed the career wish and paid lifetime happiness")

func _test_build_buy_place_rotate_reject_sell() -> void:
	var grid: BuildGridSystem = main.parity_hub.build_grid
	main.household_system.active_household_id = "household_founders"
	var catalog := ContentRegistry.get_object("park_bench")
	var price := int(catalog.get("price", 0))
	var funds_before := main.household_system.funds()
	var objects_before := main.world_builder.objects.size()
	var spot := Vector3(-16.0, 0.0, -13.0)
	main.placement_catalog_id = "park_bench"
	main.placement_rotation_y = 0.0
	main._place_catalog_object(spot)
	if not _check_equal(main.world_builder.objects.size(), objects_before + 1, "Build/Buy placed the object"):
		return
	var placed: InteractableObject = main.world_builder.objects[main.world_builder.objects.size() - 1]
	_check_equal(main.household_system.funds(), funds_before - price, "placement debited the catalog price")
	_check_equal(placed.owner_household_id, "household_founders", "placed object is owned by the active household")

	placed.rotate_quarter_turn()
	_check_near(placed.rotation.y, PI * 0.5, 0.001, "object rotated by one quarter turn")
	var asymmetric := Vector2i(2, 1)
	_check_equal(grid.rotated_footprint(asymmetric, PI * 0.5), Vector2i(1, 2), "rotation swaps an asymmetric footprint")

	var overlap: Dictionary = grid.validate_placement(placed.global_position, placed.footprint, 0.0)
	_check(not bool(overlap.get("ok", true)), "overlapping placement is rejected")
	var off_lot: Dictionary = grid.validate_placement(Vector3(0.0, 0.0, 0.0), Vector2i.ONE, 0.0)
	_check(not bool(off_lot.get("ok", true)), "placement outside any buildable lot is rejected")

	# Community property and other households' property must not be sellable.
	var community := _find_object("park_bench")
	if community != null and community != placed:
		main.selected_object = community
		_check(not bool(main.can_sell_object(community).get("ok", true)), "community property cannot be sold")
	var bell_object := _find_owned_object("household_bell")
	if bell_object != null:
		_check(not bool(main.can_sell_object(bell_object).get("ok", true)), "another household's property cannot be sold")

	var funds_before_sale := main.household_system.funds()
	main.selected_object = placed
	_check(bool(main.can_sell_object(placed).get("ok", false)), "owned object on the home lot is sellable")
	main._sell_selected_object()
	_check_equal(main.household_system.funds(), funds_before_sale + int(round(price * 0.5)), "sale refunded half the price")
	_check_equal(main.world_builder.objects.size(), objects_before, "sold object was removed from the world")

func _test_mode_and_input_policy() -> void:
	var controller: ModeController = main.mode_controller
	controller.request_mode("live")
	controller.request_speed(SimulationClock.SpeedMode.NORMAL)
	_check_equal(controller.current_mode, "live", "starting mode is live")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.NORMAL, "live mode runs the clock")
	_check(not main.hud.cas_panel.visible, "CAS panel hidden in live mode")

	main._on_mode_requested("cas")
	_check_equal(controller.current_mode, "cas", "CAS entry goes through the mode authority")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.PAUSED, "CAS pauses the simulation")
	_check(main.hud.cas_panel.visible, "CAS panel visible in CAS mode")
	_check_equal(AudioService.current_music_mode, "cas", "CAS music mode applied")
	_check(not controller.request_speed(SimulationClock.SpeedMode.ULTRA), "speed requests are refused outside live mode")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.PAUSED, "refused speed request left the clock paused")
	_check(not controller.request_pause_toggle(), "pause toggle is refused outside live mode")

	main.hud._apply_cas()
	_check_equal(controller.current_mode, "live", "applying CAS returns to live mode")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.NORMAL, "live speed restored after CAS")
	_check(not main.hud.cas_panel.visible, "CAS panel hidden after apply")
	_check_equal(AudioService.current_music_mode, "live", "live music mode restored after CAS")

	main._on_mode_requested("cas")
	main.hud._close_cas()
	_check_equal(controller.current_mode, "live", "closing CAS returns to live mode")
	_check(not main.hud.cas_panel.visible, "CAS panel hidden after close")

	main._on_mode_requested("build_buy")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.PAUSED, "Build/Buy pauses the simulation")
	main._on_mode_requested("map")
	_check_equal(SimulationClock.speed_mode, SimulationClock.SpeedMode.PAUSED, "map mode pauses the simulation")
	main._on_mode_requested("live")
	_check(controller.is_gameplay_input_allowed(), "gameplay input allowed when no text field has focus")
	main.hud.cas_first_name.grab_focus()
	_check(controller.is_text_focused(), "text focus detected while a LineEdit owns focus")
	_check(not controller.is_gameplay_input_allowed(), "gameplay input suppressed while typing")
	main.hud.cas_first_name.release_focus()
	_check(controller.is_gameplay_input_allowed(), "gameplay input restored after focus release")

func _test_age_geometry() -> void:
	var sim: SimAgent = main.sims[0]
	var original_stage := sim.profile.age_stage
	sim.profile.age_stage = "child"
	sim.refresh_profile_visuals()
	var shape := _capsule_for(sim)
	if not _check(shape != null, "Sim collision capsule is reachable"):
		return
	_check_near(shape.height, 1.1, 0.001, "child age stage shrinks the collision capsule")
	sim.profile.age_stage = "adult"
	sim.refresh_profile_visuals()
	_check_near(_capsule_for(sim).height, 1.6, 0.001, "adult age stage restores the collision capsule")
	sim.profile.age_stage = original_stage
	sim.refresh_profile_visuals()

func _test_household_ownership_coherence() -> void:
	var bell_sim := _sim_in_household("household_bell")
	if not _check(bell_sim != null, "a Bell household Sim exists"):
		return
	main._select_sim(bell_sim)
	_check_equal(main.household_system.active_household_id, "household_bell",
		"selecting a Sim switches the active household")
	_check_equal(main.household_system.funds(), main.household_system.household_funds("household_bell"),
		"HUD funds follow the active household")
	var bell_before := main.household_system.household_funds("household_bell")
	var founders_before := main.household_system.household_funds("household_founders")
	main._on_interaction_completed(bell_sim, {"id": "paid_gig", "earnings": 120, "motive_effects": {}})
	_check_equal(main.household_system.household_funds("household_bell"), bell_before + 120,
		"earnings credit the acting Sim's own household")
	_check_equal(main.household_system.household_funds("household_founders"), founders_before,
		"earnings do not leak into another household")
	_check_equal(main.household_system.home_lot_id("household_bell"), "lot_neighbor_a",
		"households carry a canonical home lot id")
	_check(main.world_system.lots.has("lot_founders"), "lots are registered into WorldSystem")
	main._select_sim(main.sims[0])

func _test_services() -> void:
	var sim := _sim_in_household("household_founders")
	if not _check(sim != null, "a founders household Sim exists"):
		return
	main._select_sim(sim)
	var household_id := sim.profile.household_id
	main.parity_hub.services.requests.clear()
	main._on_service_requested("maid")
	_check(main.parity_hub.services.requests.size() > 0, "service request was scheduled")
	var arrived: Array[Dictionary] = main.parity_hub.services.tick(60.0)
	_check(arrived.size() > 0, "service arrived after its ETA elapsed")
	for request in arrived:
		main._on_service_arrived(String(request.get("service_id", "")), String(request.get("household_id", "")), request)
	var found_moodlet := false
	for member_id in Array(Dictionary(main.household_system.households[household_id]).get("sim_ids", [])):
		for entry in main.moodlet_system.entries_for(String(member_id)):
			if String(Dictionary(entry).get("id", "")) == "tidy_home":
				found_moodlet = true
	_check(found_moodlet, "maid service applied a real household effect")

	var delivery_target := String(sim.profile.sim_id)
	var items_before := main.inventory_system.items_for_sim(delivery_target).size()
	main._on_service_arrived("delivery", household_id, {})
	_check(main.inventory_system.items_for_sim(delivery_target).size() > items_before,
		"delivery service added a real inventory item")

func _test_school_and_homework() -> void:
	var student := _sim_with_age_stage("teen")
	if not _check(student != null, "a school-age Sim exists"):
		return
	var school: SchoolSystem = main.parity_hub.school
	school.students.erase(student.profile.sim_id)
	school.tick(student.profile, 9, 1, 240.0)
	_check(school.is_at_school(student.profile.sim_id), "student is in the school rabbit hole during class hours")
	var state: Dictionary = school.students[student.profile.sim_id]
	_check(float(state.get("attendance_minutes", 0.0)) >= 240.0, "attendance minutes accrue during class")
	var homework_before := float(state.get("homework", 0.0))
	main.parity_hub.record_interaction(student, {"id": "do_homework", "special": "do_homework", "homework_amount": 45.0}, main.inventory_system)
	_check(float(Dictionary(school.students[student.profile.sim_id]).get("homework", 0.0)) > homework_before,
		"homework interaction raised homework completion")
	school.advance_day()
	_check_equal(int(Dictionary(school.students[student.profile.sim_id]).get("days_attended", 0)), 1,
		"a full attendance day increments days_attended")
	school.tick(student.profile, 20, 1, 1.0)
	_check(not school.is_at_school(student.profile.sim_id), "student leaves school outside class hours")

func _test_death_and_ghost() -> void:
	var death: DeathSystem = main.parity_hub.death
	var victim := _sim_in_household("household_founders")
	if not _check(victim != null, "a Sim is available for the mortality path"):
		return
	if main.sims.size() < 2:
		return
	var sim_id := victim.profile.sim_id
	var sims_before := main.sims.size()
	victim.motives["hunger"] = 0.0
	death.starvation_minutes[sim_id] = DeathSystem.STARVATION_MINUTES
	var died := main._check_death(victim)
	_check(died, "starvation triggered a real death")
	_check(death.is_deceased(sim_id), "death was recorded with an urn/ghost entry")
	_check(bool(Dictionary(death.ghosts.get(sim_id, {})).get("active", false)), "ghost state was activated")
	_check_equal(main.sims.size(), sims_before - 1, "deceased Sim was removed from the playable roster")
	var members: Array = Array(Dictionary(main.household_system.households["household_founders"]).get("sim_ids", []))
	_check(sim_id not in members, "deceased Sim was removed from the household roster")

func _test_pet_data_contract() -> void:
	# Pets are a persistent data contract in this build: there is no in-world
	# PetAgent, selection or routing, and the feature ledger says so.
	var pets: PetSystem = main.parity_hub.pets
	_check(pets.pets.size() > 0, "seeded pet records exist")
	var pet_id := String(pets.pets.keys()[0])
	var hunger_before := float(Dictionary(Dictionary(pets.pets[pet_id]).get("motives", {})).get("hunger", 0.0))
	pets.tick(600.0)
	_check(float(Dictionary(Dictionary(pets.pets[pet_id]).get("motives", {})).get("hunger", 0.0)) < hunger_before,
		"pet motives decay over simulated time")
	pets.interact(pet_id, "feed_pet", main.sims[0].profile.sim_id)
	_check(float(Dictionary(Dictionary(pets.pets[pet_id]).get("motives", {})).get("hunger", 0.0)) > 0.0,
		"pet interaction updates pet state")
	var in_world := false
	for child in main.get_children():
		if child is SimAgent and String((child as SimAgent).profile.sim_id).begins_with("pet_"):
			in_world = true
	_check(not in_world, "pets are data-only in this build, matching the downgraded ledger evidence")

func _test_pack_runtime_slices() -> void:
	var sim: SimAgent = main.sims[0]
	for pack_id in PACK_IDS:
		var catalog := _catalog_object_for_pack(pack_id)
		if not _check(not catalog.is_empty(), "pack %s has a runtime-wired catalog object" % pack_id):
			continue
		var object := main.world_builder.spawn_object(String(catalog.get("id", "")), Vector3(-14.0, 0.0, -10.0))
		if not _check(object != null, "pack %s object instantiates in the engine" % pack_id):
			continue
		var interactions: Array = Array(catalog.get("interactions", []))
		if not _check(not interactions.is_empty(), "pack %s object exposes an interaction" % pack_id):
			main.world_builder.remove_object(object)
			continue
		var interaction_id := String(Dictionary(interactions[0]).get("id", ""))
		var runtime: Dictionary = object.build_runtime_interaction(interaction_id, sim.global_position)
		_check(not runtime.is_empty(), "pack %s runtime interaction builds" % pack_id)
		var memories_before := Array(Dictionary(main.parity_hub.expansions.state["EP04"]["memories"]).get(sim.profile.sim_id, [])).size()
		main._on_interaction_completed(sim, runtime)
		var memories_after := Array(Dictionary(main.parity_hub.expansions.state["EP04"]["memories"]).get(sim.profile.sim_id, [])).size()
		_check(memories_after > memories_before, "pack %s interaction ran the completion path" % pack_id)
		main.world_builder.remove_object(object)
	# The arcade must not touch Showtime performance statistics.
	var performances_before := int(main.parity_hub.expansions.state["EP06"]["performances"])
	main.parity_hub.expansions.record_interaction(sim.profile, {"id": "play_arcade", "pack_id": "SP07"})
	_check_equal(int(main.parity_hub.expansions.state["EP06"]["performances"]), performances_before,
		"arcade play does not increment Showtime performance count")

func _test_save_load_round_trip() -> void:
	main._on_mode_requested("live")
	var sim: SimAgent = main.sims[0]
	main._select_sim(sim)
	# Build a distinctive state across every subsystem in the save contract.
	main.parity_hub.build_grid.grid_size = 1.5
	sim.global_position = Vector3(-15.0, 0.0, -12.0)
	sim.profile.age_stage = "adult"
	sim.profile.genetics["hair_color"] = "auburn"
	main.moodlet_system.add(sim.profile.sim_id, "round_trip", "Round Trip", 7, 500.0, "test")
	main.inventory_system.add_personal(sim.profile.sim_id, {"id": "round_trip_item", "name": "Round Trip Item"})
	main.wish_system.lifetime_happiness[sim.profile.sim_id] = 4242
	main.relationship_system.adjust(sim.profile.sim_id, main.sims[1].profile.sim_id, 11.0, 3.0)
	main.world_system.travel_to("travel_france")
	main.parity_hub.fishing.catches["trout"] = 9
	main.parity_hub.school.students["round_trip_student"] = {"grade": 91.0, "homework": 55.0, "attendance_minutes": 12.0, "days_attended": 4}
	AudioService.set_master_gain_db(-11.0)
	main.placement_catalog_id = "park_bench"
	main.placement_rotation_y = PI * 0.5
	main._place_catalog_object(Vector3(-13.0, 0.0, -16.0))
	var saved_object: InteractableObject = main.world_builder.objects[main.world_builder.objects.size() - 1]
	var saved_object_rotation := saved_object.rotation.y
	var saved_object_count := main.world_builder.objects.size()
	var saved_owner := saved_object.owner_household_id
	var saved_minutes := SimulationClock.current_total_minutes()
	var saved_funds := main.household_system.funds()
	var saved_active := main.household_system.active_household_id
	var saved_relationship := float(main.relationship_system.get_relationship(sim.profile.sim_id, main.sims[1].profile.sim_id)["long_term"])
	var saved_weather := main.weather_system.current_weather

	_check(SaveService.save_game(main._serialize_game(), SAVE_SLOT), "save wrote a verified slot")

	# Perturb everything before restoring.
	SimulationClock.elapsed_sim_minutes = saved_minutes + 5000.0
	main.household_system.change_household_funds(saved_active, -100)
	main.moodlet_system.moodlets.clear()
	main.inventory_system.personal.clear()
	main.wish_system.lifetime_happiness[sim.profile.sim_id] = 0
	main.world_system.travel_to("founders_cove")
	main.parity_hub.fishing.catches.clear()
	main.parity_hub.school.students.clear()
	main.parity_hub.build_grid.grid_size = 1.0
	AudioService.set_master_gain_db(-7.0)

	var loaded: Dictionary = SaveService.load_game(SAVE_SLOT)
	if not _check(not loaded.is_empty(), "save slot loaded back"):
		return
	main._restore_game(loaded)
	await get_tree().process_frame

	_check_near(float(SimulationClock.current_total_minutes()), float(saved_minutes), 2.0, "clock restored")
	_check(main.sims.size() > 0, "Sims restored from save")
	_check_equal(main.household_system.funds(), saved_funds, "household funds restored")
	_check_equal(main.household_system.active_household_id, saved_active, "active household restored")
	_check_equal(main.world_builder.objects.size(), saved_object_count, "object count restored")
	_check_near(main.parity_hub.build_grid.grid_size, 1.5, 0.001, "saved grid size restored")
	_check_near(AudioService.master_gain_db, -11.0, 0.001, "audio settings restored")
	_check_equal(main.world_system.active_world_id, "travel_france", "world state restored")
	_check_equal(int(main.parity_hub.fishing.catches.get("trout", 0)), 9, "parity-system state restored")
	_check(main.parity_hub.school.students.has("round_trip_student"), "school state restored")
	_check_equal(int(main.wish_system.lifetime_happiness.get(main.sims[0].profile.sim_id, 0)), 4242, "wish state restored")
	_check_near(float(main.relationship_system.get_relationship(main.sims[0].profile.sim_id, main.sims[1].profile.sim_id)["long_term"]),
		saved_relationship, 0.001, "relationships restored")
	_check_equal(main.weather_system.current_weather, saved_weather, "weather restored")
	# _restore_game frees and respawns every Sim node, so the pre-save reference
	# must not be reused here.
	var restored_sim: SimAgent = main.sims[0]
	_check_equal(String(restored_sim.profile.genetics.get("hair_color", "")), "auburn", "genetics restored")
	_check(main.moodlet_system.entries_for(restored_sim.profile.sim_id).size() > 0, "moodlets restored")
	_check(main.inventory_system.items_for_sim(restored_sim.profile.sim_id).size() > 0, "inventory restored")
	var rotation_restored := false
	var owner_restored := false
	for object in main.world_builder.objects:
		if absf(object.rotation.y - saved_object_rotation) < 0.001:
			rotation_restored = true
		if object.owner_household_id == saved_owner and saved_owner != "":
			owner_restored = true
	_check(rotation_restored, "object rotation restored")
	_check(owner_restored, "object ownership restored")
	_check_equal(main.mode_controller.current_mode, "live", "mode restored")

	# A malformed object entry must be skipped rather than crash the restore.
	var damaged := loaded.duplicate(true)
	damaged["objects"] = [{"catalog_id": "park_bench", "position": [1.0]}, {"catalog_id": "", "position": [0.0, 0.0, 0.0]}]
	main._restore_game(damaged)
	await get_tree().process_frame
	_check_equal(main.world_builder.objects.size(), 0, "malformed object entries are rejected safely")
	main._restore_game(loaded)
	await get_tree().process_frame

func _test_backup_recovery() -> void:
	var state := main._serialize_game()
	_check(SaveService.save_game(state, SAVE_SLOT), "first save for backup chain")
	_check(SaveService.save_game(state, SAVE_SLOT), "second save produced a backup")
	_check(FileAccess.file_exists(SAVE_SLOT + SaveService.BACKUP_SUFFIX), "backup file exists")
	var corrupt := FileAccess.open(SAVE_SLOT, FileAccess.WRITE)
	corrupt.store_string("{ this is not valid json")
	corrupt.close()
	var recovered: Dictionary = SaveService.load_game(SAVE_SLOT)
	_check(not recovered.is_empty(), "corrupt primary save recovered from the local backup")
	_check(recovered.has("clock") and recovered.has("sims"), "recovered backup contains a complete state payload")
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_SLOT))
	DirAccess.remove_absolute(ProjectSettings.globalize_path(SAVE_SLOT + SaveService.BACKUP_SUFFIX))

func _test_offline_only() -> void:
	# Nothing in the running tree may depend on network access or credentials.
	var network_nodes := 0
	for node in _all_nodes(get_tree().get_root()):
		if node is HTTPRequest:
			network_nodes += 1
	_check_equal(network_nodes, 0, "no HTTP client nodes exist in the running scene tree")
	var missing_assets := 0
	for alias_id in AssetLibrary.aliases.keys():
		if not ResourceLoader.exists(String(AssetLibrary.aliases[alias_id])):
			missing_assets += 1
	_check_equal(missing_assets, 0, "every referenced asset is bundled locally")
	_check(AssetLibrary.instantiate_model("fridge_basic") != null, "bundled model instantiates without external downloads")

# ------------------------------------------------------------------- utilities

func _files_with_suffix(directory: String, suffix: String) -> Array[String]:
	var result: Array[String] = []
	var dir := DirAccess.open(directory)
	if dir == null:
		return result
	dir.list_dir_begin()
	var entry := dir.get_next()
	while entry != "":
		if entry.begins_with("."):
			entry = dir.get_next()
			continue
		var full := "%s/%s" % [directory, entry]
		if dir.current_is_dir():
			result.append_array(_files_with_suffix(full, suffix))
		elif entry.ends_with(suffix):
			result.append(full)
		entry = dir.get_next()
	dir.list_dir_end()
	return result

func _all_nodes(root: Node) -> Array[Node]:
	var result: Array[Node] = [root]
	for child in root.get_children():
		result.append_array(_all_nodes(child))
	return result

func _find_object(catalog_id: String) -> InteractableObject:
	for object in main.world_builder.objects:
		if object.catalog_id == catalog_id:
			return object
	return null

func _find_owned_object(household_id: String) -> InteractableObject:
	for object in main.world_builder.objects:
		if object.owner_household_id == household_id:
			return object
	return null

func _sim_with_career() -> SimAgent:
	for sim in main.sims:
		if sim.profile.career_id != "unemployed":
			return sim
	return null

func _sim_in_household(household_id: String) -> SimAgent:
	for sim in main.sims:
		if sim.profile.household_id == household_id:
			return sim
	return null

func _sim_with_age_stage(stage: String) -> SimAgent:
	for sim in main.sims:
		if sim.profile.age_stage == stage:
			return sim
	return null

func _capsule_for(sim: SimAgent) -> CapsuleShape3D:
	for child in sim.get_children():
		if child is CollisionShape3D and (child as CollisionShape3D).shape is CapsuleShape3D:
			return (child as CollisionShape3D).shape
	return null

func _catalog_object_for_pack(pack_id: String) -> Dictionary:
	for item in ContentRegistry.objects:
		var entry: Dictionary = item
		if String(entry.get("pack_id", "")) == pack_id and not Array(entry.get("interactions", [])).is_empty():
			return entry
	return {}

func _finish() -> void:
	# Free the instantiated world and let deferred queue_free() deletions drain
	# so exit-time leak diagnostics stay clean and a genuine leak stays visible.
	if main != null and is_instance_valid(main):
		remove_child(main)
		main.free()
		main = null
	for _index in 4:
		await get_tree().process_frame
	if failures.is_empty():
		print("OPENLIFE_INTEGRATION_PASS: %d checks" % checks)
		get_tree().quit(0)
	else:
		for failure in failures:
			printerr("OPENLIFE_INTEGRATION_FAIL: %s" % failure)
		printerr("OPENLIFE_INTEGRATION_SUMMARY: %d of %d checks failed" % [failures.size(), checks])
		get_tree().quit(1)
