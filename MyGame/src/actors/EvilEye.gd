extends Actor

onready var attSprite = $EvilEyeAttack
onready var deathSprite = $EvilEyeDeath
onready var fliSprite = $EvilEyeFlight
onready var hitSprite = $EvilEyeTakeHit
onready var animator = $EvilEyeAnimation
var direction = Vector2.ZERO

var max_speed = 200
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var is_attack_on = false
var steering
var damage = 10

# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 150
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		steering = direction - velocity
		velocity = velocity + steering
		velocity = move_and_slide(velocity)
		if (velocity.x >= 0) and not is_attack_on:
			animator.play("flight")
		elif not is_attack_on:
			animator.play("flight_left")
		if (velocity.x >= 0) and is_attack_on:
			animator.play("EvilEyeAttack")
		elif is_attack_on:
			animator.play("EvilEyeAttackLeft")

	if speed > max_speed:
		speed = speed - 10

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

func _on_AttRange_body_entered(body):
	is_attack_on = true
	fliSprite.hide()
	attSprite.show()
	if (velocity.x >= 0) and is_attack_on:
		animator.play("EvilEyeAttack")
	elif is_attack_on:
		animator.play("EvilEyeAttackLeft")
	speed = 300
	pass # Replace with function body.

func _on_AttRange_body_exited(body):
	is_attack_on=false
	attSprite.hide()
	fliSprite.show()
	if (velocity.x > 0):
		animator.play("flight")
	else:
		animator.play("flight_left")
	pass # Replace with function body.


func _on_attArea_body_entered(body):
	body.take_damage(damage)
