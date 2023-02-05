extends KinematicBody2D

onready var attSprite = $amongusSprite
onready var animator = $amongusAnimation
var is_attack_on = false
var direction = Vector2.ZERO
var speed = 90
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		steering = direction - velocity
		velocity = move_and_slide(velocity + steering)
	if (velocity.x >= 0) and not is_attack_on:
		animator.play("amongusWalk")
	elif not is_attack_on:
		animator.play("amongusWalkLeft")
	elif (velocity.x >= 0) and is_attack_on:
		animator.play("amongusAttack")
	else:
		animator.play("amongusAttackLeft")
	pass

func _on_mongusRun_body_entered(body):
	is_in_area = true
	mybody = body
	pass # Replace with function body.


func _on_mongus_body_entered(body):
	is_attack_on = true
	if (velocity.x >= 0):
		animator.play("amongusAttack")
	else:
		animator.play("amongusAttackLeft")
	pass # Replace with function body.


func _on_mongus_body_exited(body):
	is_in_area = false
	animator.play("amongusIdle")
	pass


func _on_mongusRun_body_exited(body):
	is_attack_on = false
	if (velocity.x >= 0):
		animator.play("amongusWalk")
	else:
		animator.play("amongusWalkLeft")
	pass

