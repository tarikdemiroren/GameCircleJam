extends Actor

onready var attSprite = $MushroomAttack
onready var deathSprite = $MushroomDeath
onready var idleSprite = $MushroomIdle
onready var hitSprite = $MushroomTakeHit
onready var runSprite = $MushroomRun
onready var animator = $MushroomAnimation
var is_attack_on = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering
var dead = false
var damage = 15


# Called when the node enters the scene tree for the first time.
func _ready():
	attSprite.hide()
	runSprite.hide()
	health = 100
	speed = 100
	pass # Replace with function body.
	
func take_damage(amount: int ):
	set_physics_process_internal(false)
	attSprite.hide()
	idleSprite.hide()
	runSprite.hide()
	hitSprite.show()
	#animator.play("EvilEyeTakeHit")
	print(health)
	health -= amount
	print(health)
	if (health <= 0):
		dead = true
		idleSprite.hide()
		deathSprite.show()
		attSprite.hide()
		hitSprite.hide()
		animator.play("MushroomDeath")
		velocity = Vector2.ZERO
		
		
	hitSprite.hide()
	set_physics_process_internal(true)
	
func die():
	self.queue_free()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area and not dead:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		steering = direction - velocity
		velocity = move_and_slide(velocity + steering)
		if (velocity.x >= 0) and not is_attack_on:
			animator.play("MushroomRunRight")
		elif not is_attack_on:
			animator.play("MushroomRunLeft")
		elif (velocity.x >= 0) and is_attack_on:
			animator.play("MushroomAttackRight")
		else:
			animator.play("MushroomAttackLeft")
	pass

func _on_mushroomDetect_body_entered(body):
	is_in_area = true
	idleSprite.hide()
	runSprite.show()
	mybody = body
	pass # Replace with function body.


func _on_mushAttack2D_body_entered(body):
	is_attack_on = true
	runSprite.hide()
	attSprite.show()
	if (velocity.x >= 0) and not dead:
		animator.play("MushroomAttackRight")
	elif not dead:
		animator.play("MushroomAttackLeft")
	pass # Replace with function body.


func _on_mushroomDetect_body_exited(body):
	is_in_area = false
	runSprite.hide()
	idleSprite.show()
	animator.play("MushroomIdle")
	pass


func _on_mushAttack2D_body_exited(body):
	is_attack_on = false
	attSprite.hide()
	runSprite.show()
	if (velocity.x >= 0) and not dead:
		animator.play("MushroomRunRight")
	elif not dead:
		animator.play("MushroomRunLeft")
	pass


func _on_MushHurtBox_body_entered(body):
	body.take_damage(damage)
