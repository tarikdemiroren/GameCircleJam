extends Actor

signal health_changed(health)

onready var cam : Camera2D = $Camera
onready var animation_tree : AnimationTree = $PlayerAnimationTree
onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var animatior := $playerAnimationController
onready var watchSprite := $WatchMe

enum FACED_DIR {RIGHT, LEFT, UP, DOWN}
var last_dir_updo = FACED_DIR.DOWN
var last_dir_leri = FACED_DIR.RIGHT
var input_direction = Vector2()

var last_time_ult_used = null
var cutInput = false
var isSprinting = false
onready var rootSpawns1 = [$layer1/rootSpawner, $layer1/rootSpawner2, $layer1/rootSpawner3, $layer1/rootSpawner4, $layer1/rootSpawner5, $layer1/rootSpawner6, $layer1/rootSpawner7, $layer1/rootSpawner8, $layer1/rootSpawner9]
onready var rootSpawns2 = [$layer2/rootSpawner, $layer2/rootSpawner2, $layer2/rootSpawner3, $layer2/rootSpawner4, $layer2/rootSpawner5, $layer2/rootSpawner6, $layer2/rootSpawner7, $layer2/rootSpawner8, $layer2/rootSpawner9]

const MAX_HEALTH = 100
export var health = 100

func _ready() -> void:
	cam.make_current()
	animation_tree.active = true
	state_machine.travel("idle_right")
	watchSprite.hide()
	health = MAX_HEALTH
	
func take_damage(amount: int):
	health -= amount
	if health < 0:
		queue_free()
	emit_signal("health_changed", health)

func _physics_process(delta):
	get_input()
	input_direction = move_and_slide(input_direction)
	if Input.is_action_just_pressed("take_damage"):
		take_damage(9)
	
	

func get_input():
	
	input_direction = Vector2.ZERO
	isSprinting = false
	
	if not cutInput:
	
		if Input.is_action_just_pressed("ultimate_attack"):
			if last_time_ult_used == null or OS.get_unix_time() - last_time_ult_used > 10:
				last_time_ult_used = OS.get_unix_time()
				ultimate_attack()
				cutInput = true
				return
			else:
				watchSprite.show()
				animatior.play("on_cool_down")
				yield(animatior, "animation_finished")
				watchSprite.hide()
		
		if Input.is_action_pressed("right"):
			input_direction.x += 1
		if Input.is_action_pressed("left"):
			input_direction.x -= 1
		if Input.is_action_pressed("down"):
			input_direction.y += 1
		if Input.is_action_pressed("up"):
			input_direction.y -= 1
		input_direction = input_direction.normalized() * speed
		
		if Input.is_action_pressed("sprint"):
			isSprinting = true
			input_direction = input_direction * 1.5
		else:
			isSprinting = false
	
		determine_move_animation()
	

func determine_move_animation():
	
	if input_direction.length() == 0:
		if state_machine.get_current_node() == "sprint_right_1" or state_machine.get_current_node() == "walk_right_1":
			state_machine.travel("idle_right")
			return
		if state_machine.get_current_node() == "sprint_left_1" or state_machine.get_current_node() == "walk_left_1":
			state_machine.travel("idle_left")
			return
		if state_machine.get_current_node() == "sprint_down_1" or state_machine.get_current_node() == "walk_down_1":
			state_machine.travel("idle_down")
			return
		if state_machine.get_current_node() == "sprint_up_1" or state_machine.get_current_node() == "walk_up_1":
			state_machine.travel("idle_up")
		return
		
	if isSprinting:
		if input_direction.y > 0:
			state_machine.travel("sprint_down_1")
			return
		elif input_direction.y < 0:
			state_machine.travel("sprint_up_1")
			return
		#
		if input_direction.x > 0:
			state_machine.travel("sprint_right_1")
			return
		elif input_direction.x < 0:
			state_machine.travel("sprint_left_1")
			return
	else:
		if input_direction.y > 0:
			state_machine.travel("walk_down_1")
			return
		elif input_direction.y < 0:
			state_machine.travel("walk_up_1")
			return
		#
		if input_direction.x > 0:
			state_machine.travel("walk_right_1")
		elif input_direction.x < 0:
			state_machine.travel("walk_left_1")
		return

func ultimate_attack():
	state_machine.travel("gaia_s_mercy")
	for item in rootSpawns1:
		item.spawn()
	pass

func free_soul():
	cutInput = false
	
func theSecondWave():
	for item in rootSpawns2:
		item.spawn()
		

	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#func _on_playerAnimationController_animation_finished(anim_name: String) -> void:
#	if anim_name == "gaia_s_mercy":
#		for item in rootSpawns:
#			item.spawn()
	
	
