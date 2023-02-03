extends Actor

onready var cam : Camera2D = $Camera

enum FACED_DIR {RIGHT, LEFT, UP, DOWN}
var last_dir_updo = FACED_DIR.DOWN
var last_dir_leri = FACED_DIR.RIGHT
var input_direction = Vector2()


func _ready() -> void:
	#cam.make_current()
	pass

func _physics_process(delta):
	get_input()
	input_direction = move_and_slide(input_direction)

func get_input():
	input_direction = Vector2.ZERO
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
		input_direction = input_direction * 1.7
	
	determine_last_direction()

func determine_last_direction():
	if input_direction.x > 0:
		last_dir_leri = FACED_DIR.RIGHT
	elif input_direction.x < 0:
		last_dir_leri = FACED_DIR.LEFT
		
	if input_direction.y > 0:
		last_dir_updo = FACED_DIR.DOWN
	elif input_direction.y < 0:
		last_dir_updo = FACED_DIR.UP

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta: float) -> void:
#	pass
