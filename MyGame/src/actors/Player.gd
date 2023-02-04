extends Actor

onready var cam : Camera2D = $Camera
onready var animation_tree : AnimationTree = $PlayerAnimationTree
onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var animation_player := $playerAnimationController

enum FACED_DIR {RIGHT, LEFT, UP, DOWN}
var last_dir_updo = FACED_DIR.DOWN
var last_dir_leri = FACED_DIR.RIGHT
var input_direction = Vector2()

var cutInput = false
var isSprinting = false
onready var rootSpawns = [$rootSpawner, $rootSpawner2, $rootSpawner3, $rootSpawner4, $rootSpawner5, $rootSpawner6, $rootSpawner7, $rootSpawner8, $rootSpawner9]

func _ready() -> void:
	cam.make_current()
	animation_tree.active = true
	state_machine.travel("idle_right")

func _physics_process(delta):
	get_input()
	input_direction = move_and_slide(input_direction)

func get_input():
	
	input_direction = Vector2.ZERO
	isSprinting = false
	
	if not cutInput:
	
		if Input.is_action_just_pressed("ultimate_attack"):
			ultimate_attack()
			cutInput = true
			return
		
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
			input_direction = input_direction * 1.7
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
			
		elif input_direction.x < 0:
			#TODO left sprint
			pass
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
			return
		elif input_direction.x < 0:
			state_machine.travel("walk_left_1")
			return

func ultimate_attack():
	state_machine.travel("gaia_s_mercy")
	for item in rootSpawns:
		item.spawn()
	pass

func free_soul():
	cutInput = false
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#func _on_playerAnimationController_animation_finished(anim_name: String) -> void:
#	if anim_name == "gaia_s_mercy":
#		for item in rootSpawns:
#			item.spawn()
	
	
