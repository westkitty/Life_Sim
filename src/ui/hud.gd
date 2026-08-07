class_name OpenLifeHUD
extends CanvasLayer

signal sim_requested(sim_id: String)
signal interaction_requested(interaction_id: String)
signal speed_requested(speed_mode: int)
signal mode_requested(mode_id: String)
signal save_requested()
signal load_requested()
signal place_object_requested(catalog_id: String)
signal sell_selected_requested()
signal cas_apply_requested(changes: Dictionary)
signal autonomy_toggled(enabled: bool)
signal travel_requested(world_id: String)
signal occult_requested(occult_id: String)
signal service_requested(service_id: String)
signal party_requested()

var time_label: Label
var funds_label: Label
var world_label: Label
var weather_label: Label
var sim_picker: OptionButton
var sim_name_label: Label
var age_label: Label
var career_label: Label
var action_label: Label
var queue_label: RichTextLabel
var motive_bars: Dictionary = {}
var object_name_label: Label
var interaction_box: VBoxContainer
var catalog_picker: OptionButton
var pack_summary_label: Label
var notification_panel: PanelContainer
var notification_title: Label
var notification_body: Label
var notification_timer: Timer
var cas_panel: PanelContainer
var cas_first_name: LineEdit
var cas_last_name: LineEdit
var cas_age: OptionButton
var cas_trait: OptionButton
var cas_body_shape: OptionButton
var cas_skin_tone: OptionButton
var cas_hair_color: OptionButton
var cas_eye_color: OptionButton
var autonomy_check: CheckButton
var occult_picker: OptionButton
var mode_buttons: Dictionary = {}
var ui_regions: Array[Control] = []


func _apply_panel_style(panel: PanelContainer) -> void:
	var sb := StyleBoxFlat.new()
	sb.bg_color = Color(0.10, 0.13, 0.16, 0.72)
	sb.corner_radius_top_left = 10
	sb.corner_radius_top_right = 10
	sb.corner_radius_bottom_left = 10
	sb.corner_radius_bottom_right = 10
	sb.content_margin_left = 4
	sb.content_margin_right = 4
	sb.content_margin_top = 4
	sb.content_margin_bottom = 4
	sb.border_width_left = 1
	sb.border_width_right = 1
	sb.border_width_top = 1
	sb.border_width_bottom = 1
	sb.border_color = Color(1, 1, 1, 0.08)
	panel.add_theme_stylebox_override("panel", sb)

func _ready() -> void:
	layer = 20
	_build_top_bar()
	_build_sim_panel()
	_build_object_panel()
	_build_notification()
	_build_cas_panel()
	set_pack_summary()

func _build_top_bar() -> void:
	var panel := PanelContainer.new()
	_apply_panel_style(panel)
	panel.anchor_left = 0.0
	panel.anchor_right = 1.0
	panel.offset_left = 12.0
	panel.offset_right = -12.0
	panel.offset_top = 12.0
	panel.offset_bottom = 54.0
	add_child(panel)
	ui_regions.append(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 12)
	margin.add_theme_constant_override("margin_right", 12)
	margin.add_theme_constant_override("margin_top", 8)
	margin.add_theme_constant_override("margin_bottom", 8)
	panel.add_child(margin)
	var row := HBoxContainer.new()
	row.add_theme_constant_override("separation", 8)
	margin.add_child(row)

	var title := Label.new()
	title.text = "OPENLIFE"
	title.add_theme_font_size_override("font_size", 18)
	title.tooltip_text = "Clean-room, free and local life-simulation architecture"
	row.add_child(title)
	row.add_child(_v_separator())
	for mode_id in ["live", "build_buy", "cas", "map"]:
		var button := Button.new()
		button.text = mode_id.replace("_", "/").capitalize()
		button.toggle_mode = true
		button.pressed.connect(_emit_mode.bind(String(mode_id)))
		mode_buttons[mode_id] = button
		row.add_child(button)
	mode_buttons["live"].button_pressed = true
	row.add_child(_spacer())
	world_label = Label.new()
	world_label.text = "Founders Cove"
	row.add_child(world_label)
	weather_label = Label.new()
	weather_label.text = "Spring · Clear"
	row.add_child(weather_label)
	time_label = Label.new()
	time_label.text = "Day 1  08:00"
	time_label.custom_minimum_size.x = 125
	row.add_child(time_label)
	for speed_data in [[0, "Ⅱ"], [1, "▶"], [2, "▶▶"], [3, "▶▶▶"]]:
		var speed_button := Button.new()
		speed_button.text = String(speed_data[1])
		speed_button.custom_minimum_size.x = 44
		speed_button.pressed.connect(_emit_speed.bind(int(speed_data[0])))
		row.add_child(speed_button)
	funds_label = Label.new()
	funds_label.text = "§20,000"
	funds_label.custom_minimum_size.x = 105
	funds_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_RIGHT
	row.add_child(funds_label)
	row.add_child(_button("Save", func() -> void: save_requested.emit()))
	row.add_child(_button("Load", func() -> void: load_requested.emit()))

func _build_sim_panel() -> void:
	var panel := PanelContainer.new()
	_apply_panel_style(panel)
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = 12.0
	panel.offset_right = 268.0
	panel.offset_top = 64.0
	panel.offset_bottom = -12.0
	panel.modulate = Color(1, 1, 1, 0.92)
	add_child(panel)
	ui_regions.append(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	margin.add_child(column)

	var heading := Label.new()
	heading.text = "HOUSEHOLD"
	heading.add_theme_font_size_override("font_size", 13)
	column.add_child(heading)
	sim_picker = OptionButton.new()
	sim_picker.item_selected.connect(_on_sim_picker_selected)
	column.add_child(sim_picker)
	sim_name_label = Label.new()
	sim_name_label.text = "No Sim selected"
	sim_name_label.add_theme_font_size_override("font_size", 18)
	column.add_child(sim_name_label)
	age_label = Label.new()
	column.add_child(age_label)
	career_label = Label.new()
	column.add_child(career_label)
	action_label = Label.new()
	action_label.text = "Idle"
	action_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(action_label)
	column.add_child(_h_separator())
	var motive_heading := Label.new()
	motive_heading.text = "MOTIVES"
	column.add_child(motive_heading)
	for motive_id in MotiveSystem.MOTIVE_IDS:
		var row := HBoxContainer.new()
		var label := Label.new()
		label.text = motive_id.capitalize()
		label.custom_minimum_size.x = 75
		row.add_child(label)
		var bar := ProgressBar.new()
		bar.min_value = 0
		bar.max_value = 100
		bar.value = 50
		bar.show_percentage = false
		bar.size_flags_horizontal = Control.SIZE_EXPAND_FILL
		bar.custom_minimum_size.y = 12
		row.add_child(bar)
		motive_bars[motive_id] = bar
		column.add_child(row)
	column.add_child(_h_separator())
	var queue_heading := Label.new()
	queue_heading.text = "ACTION QUEUE"
	column.add_child(queue_heading)
	queue_label = RichTextLabel.new()
	queue_label.fit_content = false
	queue_label.custom_minimum_size.y = 64
	queue_label.scroll_active = true
	queue_label.bbcode_enabled = true
	column.add_child(queue_label)
	autonomy_check = CheckButton.new()
	autonomy_check.text = "Autonomy"
	autonomy_check.button_pressed = true
	autonomy_check.toggled.connect(func(enabled: bool) -> void: autonomy_toggled.emit(enabled))
	column.add_child(autonomy_check)
	column.add_child(_button("Edit Selected Sim", func() -> void: _show_cas_panel()))
	column.add_child(_button("Throw House Party", func() -> void: party_requested.emit()))
	var occult_row := HBoxContainer.new()
	occult_picker = OptionButton.new()
	occult_picker.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	for occult_id in OccultSystem.OCCULT_TYPES:
		occult_picker.add_item(occult_id.replace("_", " ").capitalize())
		occult_picker.set_item_metadata(occult_picker.item_count - 1, occult_id)
	occult_row.add_child(occult_picker)
	occult_row.add_child(_button("Add State", func() -> void: occult_requested.emit(String(occult_picker.get_selected_metadata()))))
	column.add_child(occult_row)

func _build_object_panel() -> void:
	var panel := PanelContainer.new()
	_apply_panel_style(panel)
	panel.anchor_left = 1.0
	panel.anchor_right = 1.0
	panel.anchor_top = 0.0
	panel.anchor_bottom = 1.0
	panel.offset_left = -280.0
	panel.offset_right = -12.0
	panel.offset_top = 64.0
	panel.offset_bottom = -12.0
	panel.modulate = Color(1, 1, 1, 0.92)
	add_child(panel)
	ui_regions.append(panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 14)
	margin.add_theme_constant_override("margin_right", 14)
	margin.add_theme_constant_override("margin_top", 14)
	margin.add_theme_constant_override("margin_bottom", 14)
	panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 7)
	margin.add_child(column)
	var heading := Label.new()
	heading.text = "SELECTED OBJECT"
	column.add_child(heading)
	object_name_label = Label.new()
	object_name_label.text = "Click an object in the world"
	object_name_label.add_theme_font_size_override("font_size", 15)
	object_name_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(object_name_label)
	interaction_box = VBoxContainer.new()
	interaction_box.add_theme_constant_override("separation", 5)
	column.add_child(interaction_box)
	column.add_child(_h_separator())
	var service_heading := Label.new()
	service_heading.text = "SERVICES"
	column.add_child(service_heading)
	var service_row := HBoxContainer.new()
	service_row.add_child(_button("Maid", func() -> void: service_requested.emit("maid")))
	service_row.add_child(_button("Repair", func() -> void: service_requested.emit("repair")))
	service_row.add_child(_button("Delivery", func() -> void: service_requested.emit("delivery")))
	column.add_child(service_row)
	column.add_child(_h_separator())
	var build_heading := Label.new()
	build_heading.text = "BUILD / BUY CATALOG"
	column.add_child(build_heading)
	catalog_picker = OptionButton.new()
	for item in ContentRegistry.objects:
		catalog_picker.add_item("%s — §%d" % [String(item.get("name", "Object")), int(item.get("price", 0))])
		catalog_picker.set_item_metadata(catalog_picker.item_count - 1, String(item.get("id", "")))
	column.add_child(catalog_picker)
	var build_row := HBoxContainer.new()
	build_row.add_child(_button("Place Selected", func() -> void: place_object_requested.emit(String(catalog_picker.get_selected_metadata()))))
	build_row.add_child(_button("Sell Object", func() -> void: sell_selected_requested.emit()))
	column.add_child(build_row)
	column.add_child(_h_separator())
	var travel_heading := Label.new()
	travel_heading.text = "WORLD TRAVEL CONTRACT"
	column.add_child(travel_heading)
	var travel_picker := OptionButton.new()
	for world_data in [
		["founders_cove", "Founders Cove"], ["travel_france", "Champs-sur-Similaire"],
		["travel_egypt", "Al Simhara Analog"], ["travel_china", "Shang Simla Analog"],
		["university", "OpenLife University"], ["future", "Tomorrow Landing"]
	]:
		travel_picker.add_item(String(world_data[1]))
		travel_picker.set_item_metadata(travel_picker.item_count - 1, String(world_data[0]))
	column.add_child(travel_picker)
	column.add_child(_button("Travel State", func() -> void: travel_requested.emit(String(travel_picker.get_selected_metadata()))))
	column.add_child(_h_separator())
	pack_summary_label = Label.new()
	pack_summary_label.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	pack_summary_label.add_theme_font_size_override("font_size", 10)
	pack_summary_label.modulate = Color(1, 1, 1, 0.75)
	column.add_child(pack_summary_label)

func _build_notification() -> void:
	notification_panel = PanelContainer.new()
	_apply_panel_style(notification_panel)
	notification_panel.anchor_left = 0.5
	notification_panel.anchor_right = 0.5
	notification_panel.offset_left = -260.0
	notification_panel.offset_right = 260.0
	notification_panel.offset_top = 82.0
	notification_panel.offset_bottom = 158.0
	notification_panel.visible = false
	add_child(notification_panel)
	ui_regions.append(notification_panel)
	var margin := MarginContainer.new()
	margin.add_theme_constant_override("margin_left", 16)
	margin.add_theme_constant_override("margin_right", 16)
	margin.add_theme_constant_override("margin_top", 10)
	margin.add_theme_constant_override("margin_bottom", 10)
	notification_panel.add_child(margin)
	var column := VBoxContainer.new()
	margin.add_child(column)
	notification_title = Label.new()
	notification_title.add_theme_font_size_override("font_size", 17)
	column.add_child(notification_title)
	notification_body = Label.new()
	notification_body.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(notification_body)
	notification_timer = Timer.new()
	notification_timer.one_shot = true
	notification_timer.wait_time = 4.5
	notification_timer.timeout.connect(func() -> void: notification_panel.visible = false)
	add_child(notification_timer)

func _build_cas_panel() -> void:
	cas_panel = PanelContainer.new()
	_apply_panel_style(cas_panel)
	cas_panel.anchor_left = 0.5
	cas_panel.anchor_right = 0.5
	cas_panel.anchor_top = 0.5
	cas_panel.anchor_bottom = 0.5
	cas_panel.offset_left = -280.0
	cas_panel.offset_right = 280.0
	cas_panel.offset_top = -320.0
	cas_panel.offset_bottom = 320.0
	cas_panel.modulate = Color(1, 1, 1, 0.95)
	cas_panel.visible = false
	add_child(cas_panel)
	ui_regions.append(cas_panel)
	var margin := MarginContainer.new()
	for side in ["margin_left", "margin_right", "margin_top", "margin_bottom"]:
		margin.add_theme_constant_override(side, 18)
	cas_panel.add_child(margin)
	var column := VBoxContainer.new()
	column.add_theme_constant_override("separation", 9)
	margin.add_child(column)
	var heading := Label.new()
	heading.text = "CREATE-A-SIM SHELL"
	heading.add_theme_font_size_override("font_size", 24)
	column.add_child(heading)
	cas_first_name = LineEdit.new()
	cas_first_name.placeholder_text = "First name"
	column.add_child(cas_first_name)
	cas_last_name = LineEdit.new()
	cas_last_name.placeholder_text = "Last name"
	column.add_child(cas_last_name)
	cas_age = OptionButton.new()
	for age_id in ["baby", "toddler", "child", "teen", "young_adult", "adult", "elder"]:
		cas_age.add_item(age_id.replace("_", " ").capitalize())
		cas_age.set_item_metadata(cas_age.item_count - 1, age_id)
	column.add_child(cas_age)
	cas_trait = OptionButton.new()
	# `trait` is a reserved word in GDScript 4.7; the loop variable must not use it.
	for trait_entry in ContentRegistry.traits:
		var trait_data: Dictionary = trait_entry
		cas_trait.add_item(String(trait_data.get("name", "Trait")))
		cas_trait.set_item_metadata(cas_trait.item_count - 1, String(trait_data.get("id", "")))
	column.add_child(cas_trait)
	cas_body_shape = OptionButton.new()
	for value in ["slender", "average", "athletic", "soft"]:
		cas_body_shape.add_item(value.capitalize())
		cas_body_shape.set_item_metadata(cas_body_shape.item_count - 1, value)
	column.add_child(cas_body_shape)
	cas_skin_tone = OptionButton.new()
	for value in ["light", "warm", "medium", "deep"]:
		cas_skin_tone.add_item("Skin: %s" % value.capitalize())
		cas_skin_tone.set_item_metadata(cas_skin_tone.item_count - 1, value)
	column.add_child(cas_skin_tone)
	cas_hair_color = OptionButton.new()
	for value in ["black", "brown", "auburn", "blonde"]:
		cas_hair_color.add_item("Hair: %s" % value.capitalize())
		cas_hair_color.set_item_metadata(cas_hair_color.item_count - 1, value)
	column.add_child(cas_hair_color)
	cas_eye_color = OptionButton.new()
	for value in ["brown", "hazel", "green", "blue"]:
		cas_eye_color.add_item("Eyes: %s" % value.capitalize())
		cas_eye_color.set_item_metadata(cas_eye_color.item_count - 1, value)
	column.add_child(cas_eye_color)
	var help := Label.new()
	help.text = "Applying replaces trait slot 1. The data contract supports five traits, favorites, biography, occult states, skills, career and genetics hooks."
	help.autowrap_mode = TextServer.AUTOWRAP_WORD_SMART
	column.add_child(help)
	var row := HBoxContainer.new()
	row.add_child(_button("Apply", func() -> void: _apply_cas()))
	row.add_child(_button("Close", func() -> void: _close_cas()))
	column.add_child(row)

func _apply_cas() -> void:
	var changes := {
		"first_name": cas_first_name.text.strip_edges(),
		"last_name": cas_last_name.text.strip_edges(),
		"age_stage": String(cas_age.get_selected_metadata()),
		"trait": String(cas_trait.get_selected_metadata()),
		"genetics": {
			"body_shape": String(cas_body_shape.get_selected_metadata()),
			"skin_tone": String(cas_skin_tone.get_selected_metadata()),
			"hair_color": String(cas_hair_color.get_selected_metadata()),
			"eye_color": String(cas_eye_color.get_selected_metadata()),
		},
	}
	cas_apply_requested.emit(changes)
	_close_cas()

## CAS entry and exit are always routed through the mode authority; the panel
## never shows or hides itself behind the simulation's back.
func _show_cas_panel() -> void:
	mode_requested.emit("cas")

func _close_cas() -> void:
	mode_requested.emit("live")

func set_cas_visible(value: bool) -> void:
	if cas_panel != null:
		cas_panel.visible = value

func has_text_focus() -> bool:
	var focused := get_viewport().gui_get_focus_owner() if get_viewport() != null else null
	return focused is LineEdit or focused is TextEdit

func _on_sim_picker_selected(index: int) -> void:
	if index < 0:
		return
	sim_requested.emit(String(sim_picker.get_item_metadata(index)))

func set_sim_roster(sims: Array, selected_id: String) -> void:
	sim_picker.clear()
	var selected_index := 0
	for sim in sims:
		sim_picker.add_item(sim.profile.full_name())
		sim_picker.set_item_metadata(sim_picker.item_count - 1, sim.profile.sim_id)
		if sim.profile.sim_id == selected_id:
			selected_index = sim_picker.item_count - 1
	if sim_picker.item_count > 0:
		sim_picker.select(selected_index)

func update_selected_sim(sim: SimAgent) -> void:
	if sim == null or sim.profile == null:
		return
	sim_name_label.text = sim.profile.full_name()
	age_label.text = "%s · Day %.1f" % [sim.profile.age_stage.replace("_", " ").capitalize(), sim.profile.age_days]
	career_label.text = "%s · Level %d · %.0f%%" % [sim.profile.career_id.replace("_", " ").capitalize(), sim.profile.career_level, sim.profile.career_performance]
	action_label.text = sim.display_action()
	autonomy_check.set_pressed_no_signal(sim.autonomy_enabled)
	for motive_id in MotiveSystem.MOTIVE_IDS:
		var bar: ProgressBar = motive_bars[motive_id]
		bar.value = float(sim.motives.get(motive_id, 50.0))
	queue_label.clear()
	if not sim.queue.current.is_empty():
		queue_label.append_text("[b]NOW[/b] %s\n" % String(sim.queue.current.get("name", sim.queue.current.get("id", "Interaction"))))
	for index in sim.queue.pending.size():
		var queued: Dictionary = sim.queue.pending[index]
		queue_label.append_text("%d. %s\n" % [index + 1, String(queued.get("name", queued.get("id", "Interaction")))])
	if sim.queue.current.is_empty() and sim.queue.pending.is_empty():
		queue_label.append_text("No queued actions")
	cas_first_name.text = sim.profile.first_name
	cas_last_name.text = sim.profile.last_name
	for index in cas_age.item_count:
		if String(cas_age.get_item_metadata(index)) == sim.profile.age_stage:
			cas_age.select(index)
			break
	_select_option_metadata(cas_body_shape, String(sim.profile.genetics.get("body_shape", "average")))
	_select_option_metadata(cas_skin_tone, String(sim.profile.genetics.get("skin_tone", "medium")))
	_select_option_metadata(cas_hair_color, String(sim.profile.genetics.get("hair_color", "brown")))
	_select_option_metadata(cas_eye_color, String(sim.profile.genetics.get("eye_color", "brown")))

func set_selected_object(object: InteractableObject) -> void:
	for child in interaction_box.get_children():
		child.queue_free()
	if object == null:
		object_name_label.text = "Click an object in the world"
		return
	object_name_label.text = "%s · §%d" % [object.display_name, object.price]
	for interaction in object.interactions:
		var button := Button.new()
		button.text = String(interaction.get("name", interaction.get("id", "Interaction")))
		var interaction_id := String(interaction.get("id", ""))
		button.pressed.connect(_emit_interaction.bind(interaction_id))
		interaction_box.add_child(button)

func update_clock_and_world(world_name: String, weather_text: String) -> void:
	time_label.text = SimulationClock.formatted_time()
	world_label.text = world_name
	weather_label.text = weather_text

func update_funds(amount: int) -> void:
	funds_label.text = "§%s" % _with_commas(amount)

func set_mode(mode_id: String) -> void:
	for key in mode_buttons.keys():
		mode_buttons[key].set_pressed_no_signal(String(key) == mode_id)

func is_pointer_over_ui(position: Vector2) -> bool:
	for region in ui_regions:
		if is_instance_valid(region) and region.visible and region.get_global_rect().has_point(position):
			return true
	return false

func set_pack_summary() -> void:
	var expansions := ContentRegistry.pack_count_by_type("expansion")
	var stuff_packs := ContentRegistry.pack_count_by_type("stuff")
	var counts := ContentRegistry.feature_status_counts()
	pack_summary_label.text = "Parity registry: %d expansion contracts, %d stuff-pack contracts, %d feature rows. Godot-test verified: %d. Source-wired/runtime-unverified: %d. Architecture/data contracts: %d. This panel reports scope; it does not falsely label contracts as finished features, and full Sims 3 parity is not claimed." % [
		expansions, stuff_packs, ContentRegistry.features.size(),
		int(counts.get("engine_verified", 0)),
		int(counts.get("implemented_unverified", 0)),
		int(counts.get("architecture_contract", 0)) + int(counts.get("data_contract", 0))
	]

func push_notification(title: String, body: String) -> void:
	notification_title.text = title
	notification_body.text = body
	notification_panel.visible = true
	notification_timer.start()

func _emit_mode(mode_id: String) -> void:
	mode_requested.emit(mode_id)

func _emit_speed(speed_mode: int) -> void:
	speed_requested.emit(speed_mode)

func _emit_interaction(interaction_id: String) -> void:
	interaction_requested.emit(interaction_id)

func _select_option_metadata(option: OptionButton, value: String) -> void:
	if option == null:
		return
	for index in option.item_count:
		if String(option.get_item_metadata(index)) == value:
			option.select(index)
			return

func _button(text: String, callback: Callable) -> Button:
	var button := Button.new()
	button.text = text
	button.pressed.connect(callback)
	return button

func _h_separator() -> HSeparator:
	return HSeparator.new()

func _v_separator() -> VSeparator:
	return VSeparator.new()

func _spacer() -> Control:
	var spacer := Control.new()
	spacer.size_flags_horizontal = Control.SIZE_EXPAND_FILL
	return spacer

func _with_commas(value: int) -> String:
	var text := str(abs(value))
	var result := ""
	while text.length() > 3:
		result = "," + text.substr(text.length() - 3, 3) + result
		text = text.substr(0, text.length() - 3)
	result = text + result
	return ("-" if value < 0 else "") + result

func set_selected_social_target(sim: SimAgent) -> void:
	for child in interaction_box.get_children():
		child.queue_free()
	if sim == null:
		return
	object_name_label.text = "Sim · %s" % sim.profile.full_name()
	var socials := [
		["social_chat", "Chat", 8.0, 12.0, 0.0],
		["social_joke", "Tell Joke", 6.0, 16.0, 0.0],
		["social_compliment", "Compliment", 10.0, 10.0, 1.0],
		["social_hug", "Friendly Hug", 9.0, 14.0, 1.0],
		["social_gossip", "Gossip", 2.0, 12.0, 0.0],
		["social_flirt", "Flirt", 5.0, 10.0, 12.0],
		["social_try_for_baby", "Try for Baby", 8.0, 10.0, 18.0],
		["social_argue", "Argue", -8.0, -18.0, 0.0],
	]
	for social in socials:
		var button := Button.new()
		button.text = String(social[1])
		button.tooltip_text = "Relationship Δ long %.0f / short %.0f / romantic %.0f" % [float(social[2]), float(social[3]), float(social[4])]
		var social_id := String(social[0])
		button.pressed.connect(_emit_interaction.bind(social_id))
		interaction_box.add_child(button)

func show_cas() -> void:
	set_cas_visible(true)
