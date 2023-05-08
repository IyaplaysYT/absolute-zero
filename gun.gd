extends MeshInstance

export var maxammo = 6

onready var aimray = $RayCast
onready var cam = owner.get_node("head/Camera")
onready var camray = owner.get_node("head/Camera/RayCast")
onready var anim = owner.owner.get_node("Player/AnimationPlayer")
onready var label = $Label
onready var reload_sfx = $Reload
onready var shoot_sfx = $Shoot

var target = null

func _ready():
	anim.play_backwards("aim")

func _physics_process(delta):
	label.text = maxammo as String
	if Input.is_action_just_pressed("reload"):
		anim.play("reload")
		maxammo = 6
		reload_sfx.play()
	if Input.is_action_just_pressed("aim"):
		anim.play("aim")
	elif Input.is_action_just_released("aim"):
		anim.play_backwards("aim")
	if Input.is_action_just_pressed("shoot") and !anim.get_current_animation() == "shoot" and maxammo >= 1:
		target = aimray.get_collider()
		shoot_sfx.play()
		if aimray.is_colliding() and target.is_in_group("Enemy"):
			target.health -= 100
		else:
			target = null
		maxammo -= 1
		anim.play("shoot")
