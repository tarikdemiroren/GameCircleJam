extends Actor

onready var attSprite = $FireWormAttack
onready var deathSprite = $FireWormDeath
onready var idleSprite = $FireWormIdle
onready var hitSprite = $FireWormGetHit
onready var runSprite = $FireWormWalk
onready var animator = $FireWormAnimation
onready var spawner = $fireballSpawner
var is_attack_on = false
var direction = Vector2.ZERO
var velocity = Vector2.ZERO
var mybody
var is_in_area = false
var steering
var last_ulti = null


# Called when the node enters the scene tree for the first time.
func _ready():
	speed = 120
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float):
	if is_in_area:
		direction = (mybody.global_position-self.global_position).normalized()*speed
		steering = direction - velocity
		velocity = move_and_slide(velocity + steering)
	if (velocity.x >= 0) and not is_attack_on:
		animator.play("FireWormWalk")
	elif not is_attack_on:
		animator.play("FireWormWalkLeft")
	elif ((velocity.x >= 0) and is_attack_on ) or last_ulti == null or OS.get_unix_time() - last_ulti > 5:
		last_ulti = OS.get_unix_time()
		animator.play("FireWormAttack")
	else:
		animator.play("FireWormAttackLeft")
	pass

func _on_FireWormDetect_body_entered(body):
	is_in_area = true
	idleSprite.hide()
	runSprite.show()
	mybody = body
	pass # Replace with function body.


func _on_FireWormAtt2D_body_entered(body):
	is_attack_on = true
	runSprite.hide()
	attSprite.show()
	if (velocity.x >= 0):
		animator.play("FireWormAttack")
	else:
		animator.play("FireWormAttackLeft")
	pass # Replace with function body.


func _on_FireWormDetect_body_exited(body):
	is_in_area = false
	runSprite.hide()
	idleSprite.show()
	animator.play("FireWormIdle")
	pass


func _on_FireWormAtt2D_body_exited(body):
	is_attack_on = false
	attSprite.hide()
	runSprite.show()

	pass
	
func attack():
	spawner.fireballSpawn()
