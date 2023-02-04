extends KinematicBody2D

onready var attSprite = $MushroomAttack
onready var deathSprite = $MushroomDeath
onready var idleSprite = $MushroomIdle
onready var hitSprite = $MushroomTakeHit
onready var runSprite = $MushroomRun
onready var animator = $MushroomAnimation
var is_in_attackRange = true
var direction = Vector2.ZERO
var speed = 100
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
	if ((velocity.x >= 0) and (is_in_attackRange == false)):
		animator.play("MushroomRunRight")
	elif (is_in_attackRange == false):
		animator.play("MushroomRunLeft")
	pass

func _on_mushroomDetect_body_entered(body):
	is_in_area = true
	idleSprite.hide()
	runSprite.show()
	if (velocity.x >= 0):
		animator.play("MushroomRunRight")
	else:
		animator.play("MushroomRunLeft")
	mybody = body
	pass # Replace with function body.


func _on_mushAttack2D_body_entered(body):
	is_in_attackRange = true
	runSprite.hide()
	attSprite.show()
	if (velocity.x >= 0):
		animator.play("MushroomAttackRight")
	else:
		animator.play("MushroomAttackLeft")
	pass # Replace with function body.


func _on_mushroomDetect_body_exited(body):
	is_in_area = false
	runSprite.hide()
	idleSprite.show()
	animator.play("MushroomIdle")
	pass


func _on_mushAttack2D_body_exited(body):
	is_in_attackRange = false
	attSprite.hide()
	runSprite.show()
	if (velocity.x >= 0):
		animator.play("MushroomRunRight")
	else:
		animator.play("MushroomRunLeft")
	pass
