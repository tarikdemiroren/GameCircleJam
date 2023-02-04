extends Node2D

class_name gaia_skill

var damage = 100

onready var animator := $rooter

# Declare member variables here. Examples:
# var a: int = 2
# var b: String = "text"


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animator.play("RootsUp")
	yield(animator, "animation_finished")
	queue_free()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass


func _on_rootHurtBox_body_entered(body):
	body.take_hit(damage)
