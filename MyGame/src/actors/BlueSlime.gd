extends Actor

onready var idleSprite = $BlueSlime
onready var animator = $BlueSlimeAnimation

var is_attack_on = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering
var dead = false
var damage = 5



# Called when the node enters the scene tree for the first time.
func _ready():
	health = 30
	speed = 100
	pass # Replace with function body.

func _physics_process(delta: float):
	if is_in_area and not dead:
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
	
func take_damage(amount: int ):
	set_physics_process_internal(false)
	#animator.play("EvilEyeTakeHit")
	print(health)
	health -= amount
	print(health)
	if (health <= 0):
		dead = true
		animator.play("BlueSlimeDead")
		velocity = Vector2.ZERO
		
	set_physics_process_internal(true)
	
func die():
	self.queue_free()


func _on_slimeDetect_body_entered(body):
	is_in_area = true
	mybody = body
	pass # Replace with function body.


func _on_slimeAtt_body_entered(body):
	is_attack_on = true
	if (velocity.x >= 0) and not dead:
		animator.play("BlueSlimeAttack")
	elif not dead:
		animator.play("BlueSlimeAttackLeft")
	pass # Replace with function body.


func _on_slimeDetect_body_exited(body):
	is_in_area = false
	animator.play("BlueSlimeIdle")
	pass


func _on_slimeAtt_body_exited(body):
	is_attack_on = false
	if (velocity.x >= 0) and not dead:
		animator.play("BlueSlimeWalk")
	elif not dead:
		animator.play("BlueSlimeWalkLeft")
	pass


func _on_slimeHitBox_body_entered(body):
	body.take_damage(damage)
