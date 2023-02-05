extends KinematicBody2D
class_name Actor
export var speed: = 200
const MAX_HEALTH:= 100
var health

func take_damage(amount: int):
	health -= amount
	if (health <= 0):
		queue_free()
