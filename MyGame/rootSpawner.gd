extends Position2D

var scene = load("res://src/actors/GaiaSkill.tscn")

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func spawn() -> void:
	var skill_roots = scene.instance()
	add_child(skill_roots)
	skill_roots.set_as_toplevel(true)
	skill_roots.global_position = global_position
	
