extends KinematicBody2D

onready var attSprite = $EvilEyeAttack
onready var deathSprite = $EvilEyeDeath
onready var fliSprite = $EvilEyeFlight
onready var hitSprite = $EvilEyeTakeHit
onready var animator = $EvilEyeAnimation
var direction = Vector2.ZERO
var speed = 200
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		print(mybody.position)
	steering = direction - velocity
	velocity = move_and_slide(velocity + steering)
	
	pass


func _on_DetectRange_body_entered(body):
	is_in_area = true
	mybody = body
	#direction = (body.position-self.position).normalized()
	pass # Replace with function body.


func _on_DetectRange_body_exited(body):
	is_in_area = false
	mybody = null
	pass # Replace with function body.
