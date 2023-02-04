extends Position2D

var scene = load("res://src/actors/fireball.tscn")
# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func fireballSpawn() -> void:
	var skill_fireball = scene.instance()
	add_child(skill_fireball)
	skill_fireball.set_as_toplevel(true)
	skill_fireball.global_position = global_position
