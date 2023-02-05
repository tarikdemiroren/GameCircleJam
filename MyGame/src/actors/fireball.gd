extends KinematicBody2D

class_name fireball

onready var moveSprite = $FireballMove
onready var animator = $FireballAnimation
var is_in_area = false
var direction = Vector2.ZERO
var speed = 400
var velocity = Vector2(1,1)
var mybody
var steering = Vector2.ZERO
var superKatsay = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	animator.play("FireballMove")
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		moveSprite.rotate(velocity.angle())
		steering = direction - velocity
		velocity = move_and_slide(velocity + steering*superKatsay)
	pass

func _on_FireBallHomingArea2D_body_entered(body):
	is_in_area = true
	mybody = body
	pass # Replace with function body.



func _on_FireBallHomingArea2D_body_exited(body):
	is_in_area = false
	mybody=null
	queue_free()
	pass


func _on_nothomearea_body_entered(body):
	superKatsay = 0


func _on_nothomearea_body_exited(body):
	is_in_area = true
	mybody = body


func _on_controlarea_body_exited(body):
	is_in_area = true
	mybody = body


func _on_controlarea_body_entered(body):
	is_in_area = true
	mybody = body
