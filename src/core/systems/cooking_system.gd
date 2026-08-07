class_name CookingSystem
extends Node

const RECIPES := {
	"autumn_salad": {"level": 0, "hunger": 42.0, "ingredients": ["lettuce"]},
	"waffles": {"level": 1, "hunger": 48.0, "ingredients": []},
	"spaghetti": {"level": 3, "hunger": 58.0, "ingredients": ["tomato"]},
	"grilled_salmon": {"level": 5, "hunger": 64.0, "ingredients": ["salmon"]},
	"ambrosia": {"level": 10, "hunger": 100.0, "ingredients": ["life_fruit", "deathfish"]},
}
var meals_cooked: Dictionary = {}

func can_cook(profile: SimProfile, recipe_id: String) -> bool:
	if not RECIPES.has(recipe_id):
		return false
	var skill_state: Dictionary = Dictionary(profile.skills.get("cooking", {}))
	return int(skill_state.get("level", 0)) >= int(RECIPES[recipe_id]["level"])

func cook(profile: SimProfile, recipe_id: String, servings := 1) -> Dictionary:
	if not can_cook(profile, recipe_id):
		return {}
	var key := "%s:%s" % [profile.sim_id, recipe_id]
	meals_cooked[key] = int(meals_cooked.get(key, 0)) + 1
	var recipe: Dictionary = Dictionary(RECIPES[recipe_id])
	return {"id": "meal_%s" % recipe_id, "name": recipe_id.replace("_", " ").capitalize(), "recipe_id": recipe_id, "servings": servings, "hunger": float(recipe["hunger"]), "quality": "normal"}

func serialize() -> Dictionary:
	return meals_cooked.duplicate(true)

func deserialize(data: Dictionary) -> void:
	meals_cooked = data.duplicate(true)
