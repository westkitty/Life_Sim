extends Node

signal sim_selected(sim_id: String)
signal object_selected(object_id: String)
signal interaction_queued(sim_id: String, interaction_id: String)
signal interaction_started(sim_id: String, interaction_id: String)
signal interaction_finished(sim_id: String, interaction_id: String)
signal motive_changed(sim_id: String, motive_id: String, value: float)
signal relationship_changed(sim_a: String, sim_b: String, long_term: float, short_term: float)
signal household_funds_changed(amount: int)
signal mode_changed(mode_id: String)
signal notification_posted(title: String, body: String)
signal world_state_changed()
signal save_completed(path: String)
signal load_completed(path: String)

func notify(title: String, body: String) -> void:
	notification_posted.emit(title, body)
