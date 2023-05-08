extends KinematicBody

var health = 100
var gravity_accel = 9.8
var motion = Vector3.ZERO
var speed = 2.5

enum {
	IDLE,
	ATTACK,
	RUN
}

var current_state = IDLE
var player = null

func _physics_process(delta):
	if health <= 0:
		queue_free()
	state_machine()
	motion.y -= gravity_accel * delta
	move_and_slide(motion, Vector3.UP)
		

func state_machine():
	if current_state == IDLE:
		pass
	if current_state == ATTACK:
		look_at(Vector3(player.global_transform.origin.x, player.global_transform.origin.y + 0.5, player.global_transform.origin.z), Vector3.UP)
		move_and_slide(-transform.basis.z * speed, Vector3.UP)


func _on_Area_body_entered(body):
	if body.is_in_group("Player"):
		current_state = ATTACK
		player = body



func _on_Attack_body_entered(body):
	if body.is_in_group("Player"):
		player.health -= 100
