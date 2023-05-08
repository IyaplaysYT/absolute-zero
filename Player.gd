extends KinematicBody

export var mouse_sens = 0.2
export var speed = 400
export var jump_force = 400

onready var head = $head
onready var cam = $head/Camera
onready var time = $Timer
onready var screen = $FreezeScreen
onready var anim = $AnimationPlayer
onready var pause = $Pause

var health = 100
var gravity_accel = 9.8
var motion = Vector3.ZERO

func _ready():
	screen.hide()
	pause.hide()

func _input(event):
	if event is InputEventMouseMotion and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		rotate_y(deg2rad(-1 * event.relative.x * mouse_sens))
		head.rotate_x((deg2rad(event.relative.y) * mouse_sens))
		head.rotation.x = clamp(head.rotation.x, deg2rad(-90), deg2rad(90))
	if Input.is_action_just_pressed("shoot") and Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	if Input.is_action_just_pressed("escape") and Input.mouse_mode == Input.MOUSE_MODE_CAPTURED:
		Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)

func _process(delta):
	if Input.mouse_mode == Input.MOUSE_MODE_VISIBLE:
		pause.show()
	else:
		pause.hide()
	if pause.is_visible():
		Engine.set_time_scale(0)
	elif not pause.is_visible():
		Engine.set_time_scale(1)
	elif screen.is_visible():
		Engine.set_time_scale(0.25)
	elif not screen.is_visible():
		Engine.set_time_scale(1)
		
func _physics_process(delta):
	print(time.time_left)
	if health <= 0:
		get_tree().change_scene("res://World.tscn")
	if not is_on_floor():
		motion.y -= gravity_accel * delta
	if Input.is_action_pressed("jump") and is_on_floor() :
		motion.y += jump_force * delta
	var z: float = (
		Input.get_action_strength("forward") - Input.get_action_strength("backward")
	)
	var x: float = (
		Input.get_action_strength("left") - Input.get_action_strength("right")
	)
	motion = transform.basis.xform(Vector3(x * (speed * delta), motion.y, z * (speed * delta)))
	move_and_slide(motion, Vector3.UP, true)
	if Input.is_action_pressed("slow"):
		screen.show()
		speed = 1200
	else:
		screen.hide()
		speed = 400


func _on_Win_body_entered(body):
	get_tree().change_scene("res://Level 2.tscn")

func _on_jump_body_entered(body):
	motion.y += jump_force

func _on_jump_body_exited(body):
	motion.y = 0


func _on_Final_body_entered(body):
	get_tree().change_scene("res://UI.tscn")
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)


func _on_Win1_body_entered(body):
	get_tree().change_scene("res://Level 3.tscn")


func _on_win2_body_entered(body):
	get_tree().change_scene("res://Level 4.tscn")
