class_name SchoolSystem
extends Node

var students: Dictionary = {}

func ensure_student(profile: SimProfile) -> void:
	if profile.age_stage not in ["child", "teen"]:
		return
	if not students.has(profile.sim_id):
		students[profile.sim_id] = {
			"grade": 65.0, "homework": 50.0, "attendance_minutes": 0.0,
			"days_attended": 0, "at_school": false, "day_minutes": 0.0,
		}

const SCHOOL_START_HOUR := 8
const SCHOOL_END_HOUR := 14
## Minutes of attendance that count as a full school day.
const FULL_DAY_MINUTES := 240.0

func tick(profile: SimProfile, hour: int, weekday: int, sim_minutes: float) -> void:
	ensure_student(profile)
	if not students.has(profile.sim_id):
		return
	var state: Dictionary = students[profile.sim_id]
	var in_session := weekday < 5 and hour >= SCHOOL_START_HOUR and hour < SCHOOL_END_HOUR
	# Students are in the school rabbit hole while class is in session, which is
	# the state Live mode uses to suppress free-roaming autonomy.
	state["at_school"] = in_session
	if in_session:
		state["attendance_minutes"] = float(state.get("attendance_minutes", 0.0)) + sim_minutes
		state["day_minutes"] = float(state.get("day_minutes", 0.0)) + sim_minutes
		state["grade"] = clampf(float(state.get("grade", 65.0)) + 0.004 * sim_minutes, 0.0, 100.0)
	students[profile.sim_id] = state

func is_at_school(sim_id: String) -> bool:
	return bool(Dictionary(students.get(sim_id, {})).get("at_school", false))

## Rolls the day over: attendance accrued during the previous day is converted
## into a counted school day, and unfinished homework costs grade points.
func advance_day() -> void:
	for sim_id in students.keys():
		var state: Dictionary = students[sim_id]
		if float(state.get("day_minutes", 0.0)) >= FULL_DAY_MINUTES:
			state["days_attended"] = int(state.get("days_attended", 0)) + 1
		var homework := float(state.get("homework", 0.0))
		if homework < 100.0:
			state["grade"] = clampf(float(state.get("grade", 65.0)) - 1.5, 0.0, 100.0)
		state["homework"] = maxf(0.0, homework - 40.0)
		state["day_minutes"] = 0.0
		state["at_school"] = false
		students[sim_id] = state

func complete_homework(profile: SimProfile, amount := 30.0) -> void:
	ensure_student(profile)
	if students.has(profile.sim_id):
		var state: Dictionary = students[profile.sim_id]
		state["homework"] = clampf(float(state.get("homework", 0.0)) + amount, 0.0, 100.0)
		state["grade"] = clampf(float(state.get("grade", 65.0)) + amount * 0.04, 0.0, 100.0)
		students[profile.sim_id] = state

func serialize() -> Dictionary:
	return students.duplicate(true)

func deserialize(data: Dictionary) -> void:
	students = data.duplicate(true)
