extends Actor

signal health_changed(health)
signal inevitable_death()

onready var cam : Camera2D = $Camera
onready var animation_tree : AnimationTree = $PlayerAnimationTree
onready var state_machine : AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
onready var animatior := $playerAnimationController
onready var watchSprite := $WatchMe

onready var main_sprite := $PlayerSprite
onready var close_atk_up := $CloseRangeAttackUp
onready var close_atk_lr := $CloseRangeAttackLr
onready var close_atk_down := $CloseRangeAttackDown
onready var mid_atk_up := $MidRangeAttackUp
onready var mid_atk_lr := $MidRangeAttackLr
onready var mid_atk_down := $MidRangeAttackDown

onready var hurtarea = $playerhurt/CollisionShape2D
#onready var boomerang_atk := $BoomerangAttack

onready var sprites = [main_sprite,close_atk_up,close_atk_lr,close_atk_down,mid_atk_up,mid_atk_lr,mid_atk_down]

enum DIRECTION {RIGHT, LEFT, UP, DOWN}
var input_direction = Vector2()
var last_dir

var last_time_ult_used = null
var cutInput = false
var isSprinting = false
onready var rootSpawns1 = [$layer1/rootSpawner, $layer1/rootSpawner2, $layer1/rootSpawner3, $layer1/rootSpawner4, $layer1/rootSpawner5, $layer1/rootSpawner6, $layer1/rootSpawner7, $layer1/rootSpawner8, $layer1/rootSpawner9]
onready var rootSpawns2 = [$layer2/rootSpawner, $layer2/rootSpawner2, $layer2/rootSpawner3, $layer2/rootSpawner4, $layer2/rootSpawner5, $layer2/rootSpawner6, $layer2/rootSpawner7, $layer2/rootSpawner8, $layer2/rootSpawner9]

func _ready() -> void:
	hurtarea.disabled = true
	cam.make_current()
	animation_tree.active = true
	state_machine.travel("idle_right")
	last_dir = DIRECTION.RIGHT
	watchSprite.hide()
	health = MAX_HEALTH
	
func take_damage(amount: int):
	state_machine.travel("take_damage")
	health -= amount
	if health < 0:
		emit_signal("inevitable_death")
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
		
		#
		if Input.is_action_just_pressed("close_range_atk"):
			cutInput = true
			close_attack()
			return
			
		if Input.is_action_just_pressed("mid_range_atk"):
			cutInput = true
			mid_attack()
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
			input_direction = input_direction * 1.5
		else:
			isSprinting = false
	
		determine_move_animation()
	

func determine_move_animation():
	
	if input_direction.length() == 0:
		if state_machine.get_current_node() == "sprint_right_1" or state_machine.get_current_node() == "walk_right_1":
			state_machine.travel("idle_right")
			last_dir = DIRECTION.RIGHT
			return
		if state_machine.get_current_node() == "sprint_left_1" or state_machine.get_current_node() == "walk_left_1":
			state_machine.travel("idle_left")
			last_dir = DIRECTION.LEFT
			return
		if state_machine.get_current_node() == "sprint_down_1" or state_machine.get_current_node() == "walk_down_1":
			state_machine.travel("idle_down")
			last_dir = DIRECTION.DOWN
			return
		if state_machine.get_current_node() == "sprint_up_1" or state_machine.get_current_node() == "walk_up_1":
			state_machine.travel("idle_up")
			last_dir = DIRECTION.UP
		return
		
	if isSprinting:
		if input_direction.y > 0:
			state_machine.travel("sprint_down_1")
			last_dir = DIRECTION.DOWN
			return
		elif input_direction.y < 0:
			state_machine.travel("sprint_up_1")
			last_dir = DIRECTION.UP
			return
		#
		if input_direction.x > 0:
			state_machine.travel("sprint_right_1")
			last_dir = DIRECTION.RIGHT
			return
		elif input_direction.x < 0:
			state_machine.travel("sprint_left_1")
			last_dir = DIRECTION.LEFT
			return
	else:
		if input_direction.y > 0:
			state_machine.travel("walk_down_1")
			last_dir = DIRECTION.DOWN
			return
		elif input_direction.y < 0:
			state_machine.travel("walk_up_1")
			last_dir = DIRECTION.UP
			return
		#
		if input_direction.x > 0:
			state_machine.travel("walk_right_1")
			last_dir = DIRECTION.RIGHT
		elif input_direction.x < 0:
			state_machine.travel("walk_left_1")
			last_dir = DIRECTION.LEFT
		return

func ultimate_attack():
	state_machine.travel("gaia_s_mercy")
	for item in rootSpawns1:
		item.spawn()
	pass
	
func theSecondWave():
	for item in rootSpawns2:
		item.spawn()

func free_soul():
	cutInput = false
	state_machine.travel("idle_down")
	show_sprite(main_sprite)
	
func close_attack():
	#self.scale.x > 0
	if (last_dir == DIRECTION.RIGHT):
		show_sprite(close_atk_lr)
		state_machine.travel("close_range_right")
	if (last_dir == DIRECTION.LEFT):
		show_sprite(close_atk_lr)
		state_machine.travel("close_range_left")
	if (last_dir == DIRECTION.UP):
		show_sprite(close_atk_up)
		state_machine.travel("close_range_up")
	if (last_dir == DIRECTION.DOWN):
		show_sprite(close_atk_down)
		state_machine.travel("close_range_down")
func mid_attack():
	if (last_dir == DIRECTION.RIGHT):
		show_sprite(mid_atk_lr)
		state_machine.travel("mid_range_right")
	if (last_dir == DIRECTION.LEFT):
		show_sprite(mid_atk_lr)
		state_machine.travel("mid_range_left")
	if (last_dir == DIRECTION.UP):
		show_sprite(mid_atk_up)
		state_machine.travel("mid_range_up")
	if (last_dir == DIRECTION.DOWN):
		show_sprite(mid_atk_down)
		state_machine.travel("mid_range_down")
	
	# once current yonunu anla
	# sonra sprite visibility oyna
	# ye
	
func is_turned_to_right():
	if state_machine.get_current_node() == "sprint_right_1" or state_machine.get_current_node() == "walk_right_1" or state_machine.get_current_node() == "idle_right":
		return true
	return false
func is_turned_to_left():
	if state_machine.get_current_node() == "sprint_left_1" or state_machine.get_current_node() == "walk_left_1" or state_machine.get_current_node() == "idle_left":
		return true
	return false
func is_turned_to_up():
	if state_machine.get_current_node() == "sprint_up_1" or state_machine.get_current_node() == "walk_up_1" or state_machine.get_current_node() == "idle_up":
		return true
	return false
func is_turned_to_down():
	if state_machine.get_current_node() == "sprint_down_1" or state_machine.get_current_node() == "walk_down_1" or state_machine.get_current_node() == "idle_down":
		return true
	return false

func show_sprite(lale):
	for item in sprites:
		item.hide()
	lale.show()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass

#func _on_playerAnimationController_animation_finished(anim_name: String) -> void:
#	if anim_name == "gaia_s_mercy":
#		for item in rootSpawns:
#			item.spawn()
	
	
