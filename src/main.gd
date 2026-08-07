class_name OpenLifeMain
extends Node3D

const SIM_COLORS: Array[Color] = [
	Color("#de845b"), Color("#5d98ca"), Color("#9a6bc1"), Color("#63a56d"),
	Color("#d0a148"), Color("#bb6689"), Color("#5baaa2"), Color("#8f785c")
]

var camera: Camera3D
## Camera starts framed on the founders neighborhood rather than the empty road
## junction at the world origin, so the populated lot is visible immediately.
var camera_target := Vector3(-24.0, 0.0, -24.0)
var camera_yaw := deg_to_rad(38.0)
var camera_distance := 24.0
var camera_height := 16.5
var camera_pan_speed := 17.0

var world_builder: WorldBuilder
var relationship_system: RelationshipSystem
var skill_system: SkillSystem
var career_system: CareerSystem
var aging_system: AgingSystem
var household_system: HouseholdSystem
var weather_system: WeatherSystem
var occult_system: OccultSystem
var world_system: WorldSystem
var story_progression_system: StoryProgressionSystem
var autonomy_system: AutonomySystem
var moodlet_system: MoodletSystem
var wish_system: WishSystem
var inventory_system: InventorySystem
var parity_hub: ParitySystemHub

var hud: OpenLifeHUD
var mode_controller: ModeController
var sims: Array[SimAgent] = []
var selected_sim: SimAgent
var selected_object: InteractableObject
var selected_social_target: SimAgent
var placement_catalog_id := ""
var placement_rotation_y := 0.0

var current_mode: String:
	get:
		return mode_controller.current_mode if mode_controller != null else "live"

func _ready() -> void:
	_instantiate_systems()
	_build_camera()
	world_builder.build_world(self)
	_configure_world_systems()
	_spawn_default_population()
	_build_hud()
	_connect_runtime()
	mode_controller.initialize(SimulationClock.SpeedMode.NORMAL)
	# Day 0 weather is initialized exactly once here; SimulationClock starts its
	# day bookkeeping already aligned so the first tick cannot re-roll it.
	weather_system.advance_day(0)
	_select_sim(sims[0])
	# Opening establishing shot: frame the active household's home lot so the
	# house, furniture and Sims are all on screen at launch. Later selections
	# recentre on the chosen Sim.
	_frame_active_home_lot()
	parity_hub.opportunities.offer(sims[0].profile, "opp_first_brush", "Creative Spark", ["paint", "sculpt"], 350)
	EventBus.notify("OpenLife initialized", "The local clean-room simulation project is ready. Implemented systems remain runtime-unverified until Godot execution is observed.")

func _instantiate_systems() -> void:
	world_builder = WorldBuilder.new()
	world_builder.name = "WorldBuilder"
	add_child(world_builder)
	relationship_system = RelationshipSystem.new()
	relationship_system.name = "RelationshipSystem"
	add_child(relationship_system)
	skill_system = SkillSystem.new()
	skill_system.name = "SkillSystem"
	add_child(skill_system)
	career_system = CareerSystem.new()
	career_system.name = "CareerSystem"
	add_child(career_system)
	aging_system = AgingSystem.new()
	aging_system.name = "AgingSystem"
	add_child(aging_system)
	household_system = HouseholdSystem.new()
	household_system.name = "HouseholdSystem"
	add_child(household_system)
	weather_system = WeatherSystem.new()
	weather_system.name = "WeatherSystem"
	add_child(weather_system)
	occult_system = OccultSystem.new()
	occult_system.name = "OccultSystem"
	add_child(occult_system)
	world_system = WorldSystem.new()
	world_system.name = "WorldSystem"
	add_child(world_system)
	story_progression_system = StoryProgressionSystem.new()
	story_progression_system.name = "StoryProgressionSystem"
	add_child(story_progression_system)
	autonomy_system = AutonomySystem.new()
	autonomy_system.name = "AutonomySystem"
	add_child(autonomy_system)
	moodlet_system = MoodletSystem.new()
	moodlet_system.name = "MoodletSystem"
	add_child(moodlet_system)
	wish_system = WishSystem.new()
	wish_system.name = "WishSystem"
	add_child(wish_system)
	inventory_system = InventorySystem.new()
	inventory_system.name = "InventorySystem"
	add_child(inventory_system)
	parity_hub = ParitySystemHub.new()
	parity_hub.name = "ParitySystemHub"
	add_child(parity_hub)
	mode_controller = ModeController.new()
	mode_controller.name = "ModeController"
	add_child(mode_controller)
	autonomy_system.configure(parity_hub.trait_tuning)

## Rebuilds grid, routing and lot registration from the current world contents.
func _configure_world_systems(cell_size := 1.0) -> void:
	parity_hub.configure_world(world_builder.lot_definitions, world_builder.objects, cell_size, world_builder.structure_blockers)
	for lot in world_builder.lot_definitions:
		world_system.register_lot(String(lot.get("id", "")), lot)

func _build_camera() -> void:
	camera = Camera3D.new()
	camera.name = "NeighborhoodCamera"
	camera.current = true
	# Slightly tighter FOV for life-sim composition; avoids wide-angle stretch.
	camera.fov = 42.0
	camera.near = 0.15
	camera.far = 280.0
	# Explicit cull mask: the camera must see the world render layer. Render
	# layers are deliberately separate from the physics collision layers.
	camera.cull_mask = AssetLibrary.RENDER_LAYER_WORLD
	# Soft far-plane fade cooperates with environment fog for depth.
	camera.environment = null
	add_child(camera)
	_update_camera_transform()

func _build_hud() -> void:
	hud = OpenLifeHUD.new()
	hud.name = "HUD"
	add_child(hud)
	mode_controller.configure(hud)
	hud.set_sim_roster(sims, sims[0].profile.sim_id)
	hud.update_funds(household_system.funds())

func _connect_runtime() -> void:
	SimulationClock.minute_advanced.connect(_on_minute_advanced)
	SimulationClock.day_advanced.connect(_on_day_advanced)
	EventBus.notification_posted.connect(_on_notification)
	EventBus.household_funds_changed.connect(func(amount: int) -> void: hud.update_funds(amount))
	hud.sim_requested.connect(_on_sim_requested)
	hud.interaction_requested.connect(_on_interaction_requested)
	# Speed and mode requests are only honoured through the mode authority.
	hud.speed_requested.connect(func(mode: int) -> void: mode_controller.request_speed(mode))
	hud.mode_requested.connect(_on_mode_requested)
	hud.save_requested.connect(_save_game)
	hud.load_requested.connect(_load_game)
	hud.place_object_requested.connect(_on_place_object_requested)
	hud.sell_selected_requested.connect(_sell_selected_object)
	hud.cas_apply_requested.connect(_on_cas_apply)
	hud.autonomy_toggled.connect(_on_autonomy_toggled)
	hud.travel_requested.connect(_on_travel_requested)
	hud.occult_requested.connect(_on_occult_requested)
	hud.service_requested.connect(_on_service_requested)
	hud.party_requested.connect(_on_party_requested)
	parity_hub.birth_ready.connect(_on_birth_ready)
	parity_hub.opportunity_completed.connect(_on_opportunity_completed)
	parity_hub.service_arrived.connect(_on_service_arrived)

func _spawn_default_population() -> void:
	var population := [
		{
			"sim_id": "sim_ada_rivera", "first_name": "Ada", "last_name": "Rivera", "age_stage": "young_adult",
			"genetics": {"body_shape": "slender", "skin_tone": "#c99572", "hair_color": "#3a2a24"},
			"traits": ["ambitious", "friendly", "computer_whiz", "neat", "good_sense_of_humor"],
			"career_id": "science", "career_level": 2, "career_performance": 28.0,
			"household_id": "household_founders", "biography": "A systems-minded founder building a new life in Founders Cove.",
			"position": Vector3(-18.0, 0.0, -20.0)
		},
		{
			"sim_id": "sim_milo_chen", "first_name": "Milo", "last_name": "Chen", "age_stage": "young_adult",
			"genetics": {"body_shape": "athletic", "skin_tone": "#8d5a3c", "hair_color": "#1a1a1a"},
			"traits": ["artistic", "bookworm", "natural_cook", "loves_outdoors", "family_oriented"],
			"career_id": "culinary", "career_level": 1, "career_performance": 15.0,
			"household_id": "household_founders", "biography": "A patient cook and painter who keeps the household from eating cereal forever.",
			"position": Vector3(-21.0, 0.0, -18.0)
		},
		{
			"sim_id": "sim_june_okafor", "first_name": "June", "last_name": "Okafor", "age_stage": "adult",
			"traits": ["brave", "handy", "athletic", "charismatic", "adventurous"],
			"career_id": "firefighter", "career_level": 3, "career_performance": 47.0,
			"household_id": "household_founders", "biography": "A practical firefighter with no patience for broken plumbing.",
			"position": Vector3(-24.0, 0.0, -19.0)
		},
		{
			"sim_id": "sim_rene_bell", "first_name": "Rene", "last_name": "Bell", "age_stage": "young_adult",
			"traits": ["party_animal", "virtuoso", "flirty", "charismatic", "night_owl"],
			"career_id": "music", "career_level": 2, "career_performance": 34.0,
			"household_id": "household_bell", "biography": "A neighbor with a late schedule and a louder stereo.",
			"position": Vector3(18.0, 0.0, -20.0)
		},
		{
			"sim_id": "sim_samara_bell", "first_name": "Samara", "last_name": "Bell", "age_stage": "teen",
			"traits": ["genius", "bookworm", "good", "shy", "animal_lover"],
			"career_id": "unemployed", "career_level": 0, "career_performance": 0.0,
			"household_id": "household_bell", "biography": "A student who wants a horse and an observatory, in that order.",
			"position": Vector3(22.0, 0.0, -19.0)
		},
	]
	for index in population.size():
		var data: Dictionary = population[index]
		var pos: Vector3 = data["position"]
		data.erase("position")
		_spawn_sim(data, pos, SIM_COLORS[index % SIM_COLORS.size()])
	household_system.create_household("household_founders", "Rivera-Chen-Okafor", 20000, ["sim_ada_rivera", "sim_milo_chen", "sim_june_okafor"], "lot_founders")
	household_system.create_household("household_bell", "Bell", 14500, ["sim_rene_bell", "sim_samara_bell"], "lot_neighbor_a")
	relationship_system.adjust("sim_ada_rivera", "sim_milo_chen", 58.0, 20.0, 35.0)
	relationship_system.adjust("sim_ada_rivera", "sim_june_okafor", 42.0, 10.0)
	relationship_system.adjust("sim_rene_bell", "sim_samara_bell", 76.0, 14.0)
	parity_hub.pets.ensure_seed_household("household_founders", "sim_ada_rivera")
	parity_hub.pets.ensure_seed_household("household_bell", "sim_rene_bell")
	_spawn_pet_visuals()

func _spawn_sim(data: Dictionary, position: Vector3, color: Color) -> SimAgent:
	var sim := SimAgent.new()
	sim.setup(data, color)
	sim.interaction_completed.connect(_on_interaction_completed)
	# The node must be inside the tree before a global transform is assigned.
	add_child(sim)
	sim.global_position = position
	sims.append(sim)
	if wish_system:
		wish_system.ensure_sim(sim.profile)
	if parity_hub:
		parity_hub.genetics.ensure_genetics(sim.profile)
	# Distinct default presentation palette when genetics lack visual fields.
	_ensure_visual_genetics(sim.profile)
	if sim.has_method("refresh_visuals"):
		sim.refresh_visuals()
	return sim

func _ensure_visual_genetics(profile: SimProfile) -> void:
	if profile == null:
		return
	var skins := ["#c99572", "#8d5a3c", "#e0b090", "#5c3a28", "#b97f5d", "#d4a574"]
	var hairs := ["#3a2a24", "#1a1a1a", "#6b4423", "#c4a35a", "#8b3a2a", "#4a3728"]
	var shapes := ["average", "slender", "athletic", "soft"]
	var h: int = abs(hash(profile.sim_id))
	if not profile.genetics.has("skin_tone"):
		profile.genetics["skin_tone"] = skins[h % skins.size()]
	if not profile.genetics.has("hair_color"):
		profile.genetics["hair_color"] = hairs[int(h / 3) % hairs.size()]
	if not profile.genetics.has("body_shape"):
		profile.genetics["body_shape"] = shapes[int(h / 11) % shapes.size()]


func _process(delta: float) -> void:
	_update_camera_input(delta)
	_update_camera_transform()
	_update_wall_cutaway()
	_update_environment_visuals()
	if hud:
		var world_data: Dictionary = world_system.worlds.get(world_system.active_world_id, {"name": world_system.active_world_id})
		var weather_text := "%s · %s · %.0f C" % [weather_system.current_season.capitalize(), weather_system.current_weather.capitalize(), weather_system.temperature_c]
		hud.update_clock_and_world(String(world_data.get("name", "World")), weather_text)
		if is_instance_valid(selected_sim):
			hud.update_selected_sim(selected_sim)

func _update_camera_input(delta: float) -> void:
	# While a text field owns keyboard focus the world must ignore gameplay keys,
	# otherwise typing in CAS pans, rotates or pauses the simulation.
	if mode_controller == null or not mode_controller.is_gameplay_input_allowed():
		return
	var forward_input := Input.get_action_strength("camera_forward") - Input.get_action_strength("camera_back")
	var right_input := Input.get_action_strength("camera_right") - Input.get_action_strength("camera_left")
	var forward := Vector3(-sin(camera_yaw), 0.0, -cos(camera_yaw))
	var right := Vector3(cos(camera_yaw), 0.0, -sin(camera_yaw))
	var move := forward * forward_input + right * right_input
	if move.length_squared() > 0.0:
		camera_target += move.normalized() * camera_pan_speed * delta
		camera_target.x = clampf(camera_target.x, -36.0, 36.0)
		camera_target.z = clampf(camera_target.z, -36.0, 36.0)
	var rotation_input := Input.get_action_strength("camera_rotate_right") - Input.get_action_strength("camera_rotate_left")
	camera_yaw += rotation_input * delta * 1.3
	if mode_controller.is_placement_input_allowed():
		if Input.is_action_just_pressed("rotate_placement_left"):
			placement_rotation_y = snappedf(placement_rotation_y - PI * 0.5, PI * 0.5)
			AudioService.play("ui_click")
		if Input.is_action_just_pressed("rotate_placement_right"):
			placement_rotation_y = snappedf(placement_rotation_y + PI * 0.5, PI * 0.5)
			AudioService.play("ui_click")
		if Input.is_action_just_pressed("cancel_action"):
			placement_catalog_id = ""
			AudioService.play("ui_cancel")
			EventBus.notify("Placement cancelled", "Build/Buy placement was cancelled.")
	if Input.is_action_just_pressed("pause_toggle"):
		mode_controller.request_pause_toggle()

## Centres the opening view on the active household's home lot.
func _frame_active_home_lot() -> void:
	var home_lot := household_system.home_lot_id(household_system.active_household_id)
	for lot in world_builder.lot_definitions:
		if String(lot.get("id", "")) != home_lot:
			continue
		var centre: Vector2 = lot.get("center", Vector2.ZERO)
		focus_camera_on(Vector3(centre.x, 0.0, centre.y))
		return

## Recentres the orbit camera on a world position, keeping the current yaw,
## distance and height. Clamped to the same bounds as manual panning.
func focus_camera_on(world_position: Vector3) -> void:
	camera_target = Vector3(
		clampf(world_position.x, -36.0, 36.0),
		0.0,
		clampf(world_position.z, -36.0, 36.0)
	)
	_update_camera_transform()

func _update_camera_transform() -> void:
	var horizontal := Vector3(sin(camera_yaw), 0.0, cos(camera_yaw)) * camera_distance
	camera.global_position = camera_target + horizontal + Vector3.UP * camera_height
	camera.look_at(camera_target, Vector3.UP)

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP and event.pressed:
			camera_distance = clampf(camera_distance - 3.0, 14.0, 56.0)
			camera_height = clampf(camera_height - 1.5, 12.0, 38.0)
			return
		if event.button_index == MOUSE_BUTTON_WHEEL_DOWN and event.pressed:
			camera_distance = clampf(camera_distance + 3.0, 14.0, 56.0)
			camera_height = clampf(camera_height + 1.5, 12.0, 38.0)
			return
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed and not _pointer_over_hud(event.position):
			_handle_world_click(event.position)

func _pointer_over_hud(position: Vector2) -> bool:
	return hud != null and hud.is_pointer_over_ui(position)

func _handle_world_click(screen_position: Vector2) -> void:
	var origin := camera.project_ray_origin(screen_position)
	var direction := camera.project_ray_normal(screen_position)
	var query := PhysicsRayQueryParameters3D.create(origin, origin + direction * 500.0)
	query.collision_mask = InteractableObject.LAYER_GROUND | InteractableObject.LAYER_SIM | InteractableObject.LAYER_OBJECT | InteractableObject.LAYER_STRUCTURE
	var result := get_world_3d().direct_space_state.intersect_ray(query)
	if result.is_empty():
		return
	var collider: Object = result.get("collider")
	if current_mode == "build_buy" and not placement_catalog_id.is_empty():
		var point: Vector3 = result.get("position", Vector3.ZERO)
		_place_catalog_object(point)
		return
	if collider is SimAgent:
		var clicked_sim: SimAgent = collider
		if selected_sim == clicked_sim or selected_sim == null:
			_select_sim(clicked_sim)
		else:
			selected_social_target = clicked_sim
			selected_object = null
			hud.set_selected_social_target(clicked_sim)
		return
	if collider is InteractableObject:
		selected_object = collider
		selected_social_target = null
		hud.set_selected_object(selected_object)
		return
	selected_object = null
	selected_social_target = null
	hud.set_selected_object(null)

func _on_minute_advanced(total_minutes: int, day_index: int, hour: int, _minute: int) -> void:
	for sim in sims:
		if not is_instance_valid(sim):
			continue
		var modifiers := occult_system.motive_decay_modifiers(sim.profile)
		for motive_id in MotiveSystem.MOTIVE_IDS:
			modifiers[motive_id] = float(modifiers.get(motive_id, 1.0)) * parity_hub.trait_tuning.motive_decay_modifier(sim.profile, motive_id)
		sim.tick_simulation(1.0, modifiers)
		aging_system.tick(sim.profile, 1.0)
		if hour >= 9 and hour < 16:
			var career_delta := career_system.tick_work(sim.profile, 1.0, MotiveSystem.average(sim.motives))
			if career_delta > 0.0:
				wish_system.record_career_progress(sim.profile, career_delta)
		if _check_death(sim):
			continue
		# Students in the school rabbit hole do not free-roam the lot.
		if total_minutes % 5 == 0 and not parity_hub.school.is_at_school(sim.profile.sim_id):
			var autonomous: Dictionary = autonomy_system.choose_interaction(sim, world_builder.objects)
			if not autonomous.is_empty():
				var routed := parity_hub.prepare_interaction_route(sim, autonomous)
				if not routed.is_empty():
					sim.enqueue_interaction(routed)
	relationship_system.tick(1.0)
	moodlet_system.tick(1.0)
	parity_hub.tick_minute(sims, total_minutes, day_index, hour, weather_system)

## Applies the mortality rules to one Sim and removes it from the playable
## world when it dies, leaving a ghost/urn record behind.
func _check_death(sim: SimAgent) -> bool:
	var record := parity_hub.death.evaluate(sim.profile, sim.motives, 1.0)
	if record.is_empty():
		return false
	parity_hub.death.set_ghost_active(sim.profile.sim_id, true)
	var household_id := sim.profile.household_id
	if household_system.households.has(household_id):
		var household: Dictionary = Dictionary(household_system.households[household_id])
		var ids: Array = Array(household.get("sim_ids", []))
		ids.erase(sim.profile.sim_id)
		household["sim_ids"] = ids
		household_system.households[household_id] = household
	sim.cancel_all_interactions()
	sims.erase(sim)
	if selected_sim == sim:
		selected_sim = null
	sim.queue_free()
	if not sims.is_empty():
		if selected_sim == null:
			_select_sim(sims[0])
		hud.set_sim_roster(sims, selected_sim.profile.sim_id if is_instance_valid(selected_sim) else sims[0].profile.sim_id)
	EventBus.notify("A Sim has died", "%s died of %s. A ghost record and urn were created." % [String(record.get("name", "A Sim")), String(record.get("death_type", "old age")).replace("_", " ")])
	return true

func _on_day_advanced(day_index: int) -> void:
	weather_system.advance_day(day_index)
	story_progression_system.advance_day(sims, household_system.active_household_id, relationship_system)
	parity_hub.advance_day(day_index, household_system.households, world_builder.objects.size(), weather_system)

func _on_interaction_completed(sim: SimAgent, interaction: Dictionary) -> void:
	var skill_id := String(interaction.get("skill_id", ""))
	if not skill_id.is_empty():
		skill_system.add_progress(sim.profile, skill_id, float(interaction.get("skill_points", 5.0)))
		AudioService.play("event_skill", -12.0)
	# Earnings always credit the acting Sim's own household, not merely whichever
	# household happens to be active.
	var earnings := int(interaction.get("earnings", 0))
	if earnings != 0:
		household_system.change_household_funds(sim.profile.household_id, earnings)
	var target_sim_id := String(interaction.get("target_sim_id", ""))
	if not target_sim_id.is_empty():
		relationship_system.adjust(
			sim.profile.sim_id,
			target_sim_id,
			float(interaction.get("relationship_long", 0.0)),
			float(interaction.get("relationship_short", 0.0)),
			float(interaction.get("relationship_romantic", 0.0))
		)
	var effects := Dictionary(interaction.get("motive_effects", {}))
	if float(effects.get("hunger", 0.0)) >= 30.0:
		moodlet_system.add(sim.profile.sim_id, "well_fed", "Well Fed", 10, 180.0, "interaction")
	if float(effects.get("hygiene", 0.0)) >= 25.0:
		moodlet_system.add(sim.profile.sim_id, "fresh", "Fresh", 5, 120.0, "interaction")
	if float(effects.get("fun", 0.0)) >= 20.0:
		moodlet_system.add(sim.profile.sim_id, "entertained", "Entertained", 5, 90.0, "interaction")
	var fulfilled := wish_system.record_interaction(sim.profile, interaction)
	if not fulfilled.is_empty():
		EventBus.notify("Wish fulfilled", "%s earned lifetime happiness." % sim.profile.first_name)
	parity_hub.record_interaction(sim, interaction, inventory_system)
	parity_hub.expansions.add_memory(sim.profile.sim_id, String(interaction.get("name", interaction.get("id", "Interaction"))))
	if not target_sim_id.is_empty():
		parity_hub.parties.record_social(sim.profile.sim_id, target_sim_id, float(interaction.get("relationship_short", 0.0)))
	var special := String(interaction.get("special", ""))
	match special:
		"career_picker":
			career_system.assign_career(sim.profile, "business")
			EventBus.notify("New career", "%s joined the Business career." % sim.profile.full_name())
		"spawn_plumbot":
			_spawn_plumbot_near(sim)
		"invent_result":
			inventory_system.add_personal(sim.profile.sim_id, {"id": "prototype", "name": "Prototype", "quality": "normal"})
			EventBus.notify("Invention complete", "A prototype was added to %s's inventory." % sim.profile.first_name)
		"elixir_result":
			inventory_system.add_personal(sim.profile.sim_id, {"id": "elixir", "name": "Elixir", "quality": "normal"})
		"pay_bills":
			var due := parity_hub.bills.amount_due(sim.profile.household_id)
			if due <= 0:
				EventBus.notify("Bills", "There are no outstanding bills.")
			elif household_system.change_household_funds(sim.profile.household_id, -due):
				parity_hub.bills.pay(sim.profile.household_id, due)
				AudioService.play("ui_money", -7.0)
				EventBus.notify("Bills paid", "The household paid §%d." % due)
		"birthday_age_up":
			if aging_system.age_up(sim.profile):
				AudioService.play("event_birth", -10.0)
		"alien_chance":
			if randf() < 0.1:
				EventBus.notify("Strange lights", "Something noticed %s looking back." % sim.profile.first_name)
		"try_for_baby":
			var other := _sim_by_id(target_sim_id)
			if other != null:
				var started := parity_hub.pregnancy.try_conceive(sim.profile, other.profile)
				EventBus.notify("Family planning", "A pregnancy began." if started else "No pregnancy began this time.")

func _on_interaction_requested(interaction_id: String) -> void:
	if not is_instance_valid(selected_sim):
		return
	var interaction := {}
	if is_instance_valid(selected_object):
		interaction = selected_object.build_runtime_interaction(interaction_id, selected_sim.global_position)
	elif is_instance_valid(selected_social_target):
		interaction = _build_social_interaction(interaction_id, selected_social_target)
	if interaction.is_empty():
		EventBus.notify("Interaction unavailable", "Select an object or another Sim first.")
		return
	var routed := parity_hub.prepare_interaction_route(selected_sim, interaction)
	if routed.is_empty():
		AudioService.play("ui_cancel", -5.0)
		EventBus.notify("No route", "%s cannot reach a usable spot for that interaction." % selected_sim.profile.first_name)
		return
	if not selected_sim.enqueue_interaction(routed):
		EventBus.notify("Queue full", "The selected Sim already has eight pending actions.")

func _build_social_interaction(interaction_id: String, target: SimAgent) -> Dictionary:
	return parity_hub.socials.build_interaction(selected_sim, target, interaction_id)

func _on_sim_requested(sim_id: String) -> void:
	for sim in sims:
		if sim.profile.sim_id == sim_id:
			_select_sim(sim)
			return

func _select_sim(sim: SimAgent) -> void:
	if is_instance_valid(selected_sim):
		selected_sim.set_selected(false)
	selected_sim = sim
	selected_sim.set_selected(true)
	selected_object = null
	selected_social_target = null
	# Selecting a Sim from another household switches the economic/ownership
	# context too, so the controlled actor and active household never diverge.
	var owning_household := household_system.household_for_sim(selected_sim.profile.sim_id)
	if owning_household.is_empty():
		owning_household = selected_sim.profile.household_id
	if household_system.set_active_household(owning_household):
		EventBus.notify("Household switched", "%s is now the active household." % String(household_system.active_household().get("name", owning_household)))
	# Frame the camera on the controlled Sim so the player always has the active
	# household in view instead of an arbitrary corner of the map.
	focus_camera_on(selected_sim.global_position)
	if hud:
		hud.set_sim_roster(sims, selected_sim.profile.sim_id)
		hud.set_selected_object(null)
		hud.update_funds(household_system.funds())
	AudioService.play("ui_click", -5.0)
	EventBus.sim_selected.emit(selected_sim.profile.sim_id)

func _on_mode_requested(mode_id: String) -> void:
	if not mode_controller.request_mode(mode_id):
		return
	if mode_id != "build_buy":
		placement_catalog_id = ""
	match mode_id:
		"build_buy":
			EventBus.notify("Build/Buy", "Choose an object, arm placement, then click the world. Z/X rotates placement by 90 degrees; Escape cancels.")
		"map":
			EventBus.notify("Map view", "Travel-state destinations are available in the right panel; full destination streaming remains in the parity ledger.")

func _on_place_object_requested(catalog_id: String) -> void:
	if catalog_id.is_empty():
		return
	placement_catalog_id = catalog_id
	placement_rotation_y = 0.0
	_on_mode_requested("build_buy")
	var data := ContentRegistry.get_object(catalog_id)
	EventBus.notify("Placement armed", "Click the ground to place %s." % String(data.get("name", catalog_id)))

func _place_catalog_object(point: Vector3) -> void:
	var data := ContentRegistry.get_object(placement_catalog_id)
	if data.is_empty():
		return
	var footprint := Vector2i(int(data.get("footprint_x", 1)), int(data.get("footprint_z", 1)))
	var validation := parity_hub.build_grid.validate_placement(point, footprint, placement_rotation_y)
	if not bool(validation.get("ok", false)):
		AudioService.play("ui_cancel", -5.0)
		EventBus.notify("Cannot place object", String(validation.get("reason", "Invalid placement.")))
		return
	var price := int(data.get("price", 0))
	if not household_system.change_funds(-price):
		EventBus.notify("Insufficient funds", "The active household cannot afford this object.")
		return
	var snapped: Vector3 = validation.get("position", parity_hub.build_grid.snapped_position(point))
	var object := world_builder.spawn_object(placement_catalog_id, snapped, placement_rotation_y)
	if object == null:
		household_system.change_funds(price)
		return
	object.owner_household_id = household_system.active_household_id
	if not parity_hub.register_object(object):
		world_builder.remove_object(object)
		household_system.change_funds(price)
		EventBus.notify("Cannot place object", "The object footprint could not be registered on the build grid.")
		return
	selected_object = object
	hud.set_selected_object(object)
	AudioService.play("build_place")
	EventBus.notify("Object placed", "%s was placed for §%d on %s." % [object.display_name, price, String(validation.get("lot_id", "the active lot"))])

## Sale authority: only objects owned by the active household, standing on that
## household's home lot, may be sold.
func can_sell_object(object: InteractableObject) -> Dictionary:
	if not is_instance_valid(object):
		return {"ok": false, "reason": "Select a catalog object before selling."}
	if object.owner_household_id.is_empty():
		return {"ok": false, "reason": "Community property cannot be sold."}
	if object.owner_household_id != household_system.active_household_id:
		return {"ok": false, "reason": "Only the active household may sell its own objects."}
	var home_lot := household_system.home_lot_id(household_system.active_household_id)
	var object_lot := parity_hub.build_grid.lot_for_position(object.global_position)
	if not home_lot.is_empty() and object_lot != home_lot:
		return {"ok": false, "reason": "That object is not on the active household's home lot."}
	return {"ok": true, "reason": ""}

func _sell_selected_object() -> void:
	var authority := can_sell_object(selected_object)
	if not bool(authority.get("ok", false)):
		AudioService.play("ui_cancel", -5.0)
		EventBus.notify("Cannot sell object", String(authority.get("reason", "Sale not permitted.")))
		return
	var refund := int(round(selected_object.price * 0.5))
	var sold_name := selected_object.display_name
	parity_hub.unregister_object(selected_object.object_instance_id)
	world_builder.remove_object(selected_object)
	selected_object = null
	household_system.change_funds(refund)
	hud.set_selected_object(null)
	AudioService.play("build_sell")
	EventBus.notify("Object sold", "%s sold for §%d." % [sold_name, refund])

func _on_cas_apply(changes: Dictionary) -> void:
	if not is_instance_valid(selected_sim):
		return
	var first_name := String(changes.get("first_name", "")).strip_edges()
	var last_name := String(changes.get("last_name", "")).strip_edges()
	if not first_name.is_empty():
		selected_sim.profile.first_name = first_name
	if not last_name.is_empty():
		selected_sim.profile.last_name = last_name
	selected_sim.profile.age_stage = String(changes.get("age_stage", selected_sim.profile.age_stage))
	var genetics_changes := Dictionary(changes.get("genetics", {}))
	for key in genetics_changes.keys():
		selected_sim.profile.genetics[key] = genetics_changes[key]
	var trait_id := String(changes.get("trait", ""))
	if not trait_id.is_empty():
		if selected_sim.profile.traits.is_empty():
			selected_sim.profile.traits.append(trait_id)
		else:
			selected_sim.profile.traits[0] = trait_id
	selected_sim.refresh_profile_visuals()
	hud.set_sim_roster(sims, selected_sim.profile.sim_id)
	EventBus.notify("Sim updated", "%s was updated in the current Create-a-Sim implementation." % selected_sim.profile.full_name())

func _on_opportunity_completed(_sim_id: String, household_id: String, reward: int, title: String) -> void:
	if reward <= 0 or household_id.is_empty():
		return
	if household_system.change_household_funds(household_id, reward):
		AudioService.play("ui_money", -7.0)
		EventBus.notify("Opportunity reward", "%s paid §%d to %s." % [title, reward, String(Dictionary(household_system.households.get(household_id, {})).get("name", household_id))])

## Service arrivals must produce a real household effect, not only a message.
func _on_service_arrived(service_id: String, household_id: String, _request: Dictionary) -> void:
	var member_ids: Array = Array(Dictionary(household_system.households.get(household_id, {})).get("sim_ids", []))
	match service_id:
		"maid":
			for member_id in member_ids:
				moodlet_system.add(String(member_id), "tidy_home", "Tidy Home", 12, 480.0, "service")
		"repair":
			for member_id in member_ids:
				moodlet_system.add(String(member_id), "everything_works", "Everything Works", 8, 360.0, "service")
		"delivery":
			for member_id in member_ids:
				inventory_system.add_personal(String(member_id), {"id": "grocery_box", "name": "Grocery Box", "quality": "normal", "kind": "food"})
		"babysitter":
			for member_id in member_ids:
				moodlet_system.add(String(member_id), "childcare_covered", "Childcare Covered", 6, 300.0, "service")
	EventBus.notify("Service arrived", "%s service reached %s and applied its effect." % [service_id.capitalize(), String(Dictionary(household_system.households.get(household_id, {})).get("name", household_id))])

func _on_autonomy_toggled(enabled: bool) -> void:
	if is_instance_valid(selected_sim):
		selected_sim.autonomy_enabled = enabled
	autonomy_system.autonomy_enabled = sims.any(func(sim: SimAgent) -> bool: return sim.autonomy_enabled)

func _on_service_requested(service_id: String) -> void:
	if not is_instance_valid(selected_sim):
		return
	var household_id := selected_sim.profile.household_id
	var request := parity_hub.services.request(service_id, household_id, selected_sim.global_position)
	if request.is_empty():
		return
	var cost := int(request.get("cost", 0))
	if cost > 0 and not household_system.change_household_funds(household_id, -cost):
		parity_hub.services.requests.erase(request)
		EventBus.notify("Service unavailable", "The household cannot afford this service.")
		return
	EventBus.notify("Service scheduled", "%s will arrive in about %d Sim minutes." % [service_id.capitalize(), int(request.get("eta_minutes", 30))])

func _on_party_requested() -> void:
	if not is_instance_valid(selected_sim):
		return
	var guests: Array[String] = []
	for sim in sims:
		if is_instance_valid(sim) and sim != selected_sim:
			guests.append(sim.profile.sim_id)
	var party_id := parity_hub.parties.start_party(selected_sim.profile.sim_id, guests)
	EventBus.notify("House party", "%s started with %d invited guests." % [party_id, guests.size()])

func _on_travel_requested(world_id: String) -> void:
	if world_system.travel_to(world_id):
		if is_instance_valid(selected_sim):
			parity_hub.expansions.record_world_travel(selected_sim.profile, world_id)
		EventBus.notify("World state changed", "The active world-state context changed; visa, university, and future-trip state is persisted locally.")

func _on_occult_requested(occult_id: String) -> void:
	if is_instance_valid(selected_sim):
		occult_system.add_occult(selected_sim.profile, occult_id)

func _spawn_plumbot_near(builder: SimAgent) -> void:
	var number := sims.size() + 1
	var data := {
		"sim_id": "sim_plumbot_%03d" % number,
		"first_name": "Unit", "last_name": "%03d" % number,
		"age_stage": "adult", "traits": ["bot_fan", "handy"],
		"career_id": "unemployed", "household_id": builder.profile.household_id,
		"occult_states": ["plumbot"], "biography": "A player-built synthetic household member."
	}
	var bot := _spawn_sim(data, builder.global_position + Vector3(2.0, 0.0, 0.0), Color("#7db5ba"))
	parity_hub.expansions.register_plumbot(bot.profile.sim_id, ["competent_cleaner", "friendly_functions"])
	var household: Dictionary = Dictionary(household_system.households[builder.profile.household_id])
	var ids: Array = Array(household.get("sim_ids", []))
	ids.append(bot.profile.sim_id)
	household["sim_ids"] = ids
	household_system.households[builder.profile.household_id] = household
	hud.set_sim_roster(sims, selected_sim.profile.sim_id)
	EventBus.notify("Plumbot assembled", "%s joined the household." % bot.profile.full_name())

func _save_game() -> void:
	SaveService.save_game(_serialize_game())

func _serialize_game() -> Dictionary:
	var sim_data: Array = []
	for sim in sims:
		if is_instance_valid(sim):
			sim_data.append(sim.serialize())
	var object_data: Array = []
	for object in world_builder.objects:
		if is_instance_valid(object):
			object_data.append(object.serialize())
	return {
		"clock": SimulationClock.serialize(),
		"households": household_system.serialize(),
		"relationships": relationship_system.serialize(),
		"weather": weather_system.serialize(),
		"world": world_system.serialize(),
		"moodlets": moodlet_system.serialize(),
		"wishes": wish_system.serialize(),
		"inventory": inventory_system.serialize(),
		"parity_systems": parity_hub.serialize(),
		"sims": sim_data,
		"objects": object_data,
		"selected_sim_id": selected_sim.profile.sim_id if is_instance_valid(selected_sim) else "",
		"mode": current_mode,
		"settings": {
			"audio_enabled": AudioService.enabled,
			"audio_gain_db": AudioService.master_gain_db,
			"grid_size": parity_hub.build_grid.grid_size,
		},
	}

func _load_game() -> void:
	var state := SaveService.load_game()
	if state.is_empty():
		return
	_restore_game(state)

func _restore_game(state: Dictionary) -> void:
	SimulationClock.deserialize(Dictionary(state.get("clock", {})))
	household_system.deserialize(Dictionary(state.get("households", {})))
	relationship_system.deserialize(Dictionary(state.get("relationships", {})))
	weather_system.deserialize(Dictionary(state.get("weather", {})))
	world_system.deserialize(Dictionary(state.get("world", {})))
	moodlet_system.deserialize(Dictionary(state.get("moodlets", {})))
	wish_system.deserialize(Dictionary(state.get("wishes", {})))
	inventory_system.deserialize(Dictionary(state.get("inventory", {})))
	parity_hub.deserialize(Dictionary(state.get("parity_systems", {})))
	var saved_settings := Dictionary(state.get("settings", {}))
	AudioService.set_enabled(bool(saved_settings.get("audio_enabled", true)))
	AudioService.set_master_gain_db(float(saved_settings.get("audio_gain_db", -7.0)))
	for sim in sims:
		if is_instance_valid(sim):
			sim.queue_free()
	sims.clear()
	selected_sim = null
	for index in Array(state.get("sims", [])).size():
		var sim_state: Dictionary = Array(state.get("sims", []))[index]
		var profile_data: Dictionary = Dictionary(sim_state.get("profile", {}))
		var sim := _spawn_sim(profile_data, Vector3.ZERO, SIM_COLORS[index % SIM_COLORS.size()])
		sim.deserialize(sim_state)
	world_builder.clear_objects()
	world_builder.object_counter = 0
	var rejected_objects := 0
	for object_state_variant in Array(state.get("objects", [])):
		if not (object_state_variant is Dictionary):
			rejected_objects += 1
			continue
		var object_state: Dictionary = object_state_variant
		# Object entries are schema-checked before indexing so a malformed or
		# older save degrades to a skipped object instead of a runtime error.
		var pos_array: Array = Array(object_state.get("position", []))
		if pos_array.size() < 3:
			rejected_objects += 1
			continue
		var catalog_id := String(object_state.get("catalog_id", ""))
		if catalog_id.is_empty():
			rejected_objects += 1
			continue
		var pos := Vector3(float(pos_array[0]), float(pos_array[1]), float(pos_array[2]))
		var restored := world_builder.spawn_object(catalog_id, pos)
		if restored:
			restored.rotation.y = float(object_state.get("rotation_y", 0.0))
			restored.owner_household_id = String(object_state.get("owner_household_id", ""))
		else:
			rejected_objects += 1
	if rejected_objects > 0:
		EventBus.notify("Save partially recovered", "%d unreadable object entries were skipped during load." % rejected_objects)
	# Grid size is part of the restored settings and must be applied before the
	# grid and router are rebuilt.
	_configure_world_systems(maxf(float(saved_settings.get("grid_size", 1.0)), 0.25))
	var selected_id := String(state.get("selected_sim_id", ""))
	for sim in sims:
		if sim.profile.sim_id == selected_id:
			_select_sim(sim)
			break
	if selected_sim == null and not sims.is_empty():
		_select_sim(sims[0])
	household_system.active_household_id = String(Dictionary(state.get("households", {})).get("active_household_id", household_system.active_household_id))
	_on_mode_requested(String(state.get("mode", "live")))
	hud.update_funds(household_system.funds())

func _sim_by_id(sim_id: String) -> SimAgent:
	for sim in sims:
		if is_instance_valid(sim) and sim.profile.sim_id == sim_id:
			return sim
	return null

func _on_birth_ready(mother_id: String, father_id: String) -> void:
	var mother := _sim_by_id(mother_id)
	var father := _sim_by_id(father_id)
	if mother == null or father == null:
		return
	var child_index: int = sims.size() + 1
	var child_data: Dictionary = parity_hub.genetics.make_child_profile(mother.profile, father.profile, child_index)
	var child: SimAgent = _spawn_sim(child_data, mother.global_position + Vector3(1.4, 0.0, 0.0), Color("#d8aa8c"))
	parity_hub.genealogy.record_birth(child.profile.sim_id, mother.profile.sim_id, father.profile.sim_id)
	if household_system.households.has(mother.profile.household_id):
		var household: Dictionary = household_system.households[mother.profile.household_id]
		var ids: Array = Array(household.get("sim_ids", []))
		if child.profile.sim_id not in ids:
			ids.append(child.profile.sim_id)
		household["sim_ids"] = ids
		household_system.households[mother.profile.household_id] = household
	hud.set_sim_roster(sims, selected_sim.profile.sim_id if is_instance_valid(selected_sim) else child.profile.sim_id)
	AudioService.play("event_birth", -4.0)
	EventBus.notify("New baby", "%s joined the household with inherited traits and genetics." % child.profile.full_name())

func _on_notification(title: String, body: String) -> void:
	if hud:
		hud.push_notification(title, body)

func _update_wall_cutaway() -> void:
	if world_builder == null or camera == null:
		return
	# Life-sim cutaway: when zoomed close/low enough over a home lot, hide interior partitions/ceilings.
	var close: bool = camera_distance < 22.0 and camera_height < 18.0
	world_builder.set_wall_cutaway(close)

func _update_environment_visuals() -> void:
	if world_builder == null or world_builder.world_root == null or weather_system == null:
		return
	var sun := world_builder.world_root.get_node_or_null("SunLight") as DirectionalLight3D
	var fill := world_builder.world_root.get_node_or_null("FillLight") as DirectionalLight3D
	var we := world_builder.world_root.get_node_or_null("WorldEnvironment") as WorldEnvironment
	if sun == null or we == null or we.environment == null:
		return
	var env := we.environment
	var minute: int = 8 * 60
	if SimulationClock != null:
		minute = SimulationClock.current_absolute_minutes() % 1440
	var day_t := float(minute) / 1440.0
	# Sun pitch from dawn to dusk
	var sun_pitch := -12.0
	var energy := 0.15
	var sun_color := Color("#ffd0a0")
	if day_t > 0.22 and day_t < 0.80:
		var local := (day_t - 0.22) / 0.58
		sun_pitch = lerpf(-8.0, -55.0, sin(local * PI))
		energy = lerpf(0.35, 1.1, sin(local * PI))
		sun_color = Color("#fff2df").lerp(Color("#ffe0b0"), absf(local - 0.5) * 2.0)
	elif day_t >= 0.80 or day_t <= 0.22:
		sun_pitch = -6.0
		energy = 0.08
		sun_color = Color("#8aa0c8")
	sun.rotation_degrees = Vector3(sun_pitch, -42.0, 0.0)
	sun.light_energy = energy
	sun.light_color = sun_color
	if fill:
		fill.light_energy = 0.08 if energy < 0.2 else 0.22
	# Weather tint
	match weather_system.current_weather:
		"rain", "storm":
			env.fog_density = 0.004
			env.fog_light_color = Color("#9aadb8")
			sun.light_energy *= 0.55
		"snow":
			env.fog_density = 0.0035
			env.fog_light_color = Color("#d8e4ef")
			sun.light_energy *= 0.7
			sun.light_color = Color("#e8f0ff")
		_:
			env.fog_density = 0.0018 if energy > 0.2 else 0.003
			env.fog_light_color = Color("#c5d6df") if energy > 0.2 else Color("#1a2438")
	# Night ambient
	if energy < 0.2:
		env.ambient_light_energy = 0.18
		env.ambient_light_color = Color("#2a3550")
		env.background_mode = Environment.BG_COLOR
		env.background_color = Color("#0c1220")
		env.tonemap_exposure = 0.75
	else:
		env.ambient_light_energy = 0.42
		env.ambient_light_color = Color("#e8f0ef")
		env.background_mode = Environment.BG_SKY
		env.tonemap_exposure = 0.92
	# Seasonal tint on ambient
	match weather_system.current_season:
		"autumn":
			env.ambient_light_color = env.ambient_light_color.lerp(Color("#f0d8b8"), 0.25)
		"winter":
			env.ambient_light_color = env.ambient_light_color.lerp(Color("#d0e0f0"), 0.3)
		"summer":
			sun.light_energy *= 1.08
		_:
			pass


func _spawn_pet_visuals() -> void:
	## Place species meshes for seeded pets so animals are visible in the neighborhood.
	var placements := [
		["pet_dog", Vector3(-20.0, 0.0, -18.0)],
		["pet_cat", Vector3(-17.5, 0.0, -19.5)],
		["pet_horse", Vector3(-30.0, 0.0, -14.0)],
		["pet_dog", Vector3(20.0, 0.0, -18.0)],
		["pet_cat", Vector3(22.0, 0.0, -17.0)],
	]
	for index in placements.size():
		var entry: Array = placements[index]
		var node: Node3D = AssetLibrary.instantiate_model(String(entry[0]))
		if node == null:
			continue
		node.name = "PetVisual_%02d" % index
		node.position = entry[1]
		# Ensure pets appear on the world render layer.
		for child in node.find_children("*", "MeshInstance3D", true, false):
			(child as MeshInstance3D).layers = AssetLibrary.RENDER_LAYER_WORLD
		add_child(node)
