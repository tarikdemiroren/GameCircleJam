extends Actor

onready var idleSprite = $BlueSlime
onready var animator = $BlueSlimeAnimation

var is_attack_on = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering



# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 100
	pass # Replace with function body.

func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		steering = direction - velocity
		velocity = move_and_slide(velocity + steering)
	if (velocity.x >= 0) and not is_attack_on:
		animator.play("BlueSlimeWalk")
	elif not is_attack_on:
		animator.play("BlueSlimeWalkLeft")
	elif (velocity.x >= 0) and is_attack_on:
		animator.play("BlueSlimeAttack")
	else:
		animator.play("BlueSlimeAttackLeft")
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
