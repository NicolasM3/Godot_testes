extends KinematicBody2D

const max_speed = 150
const acell = 10
const gravity =300
var   vel:Vector2 = Vector2()
var   scene_up:Vector2 = Vector2(0, -1)

func _physics_process(delta) -> void:
	var left  = Input.is_key_pressed(65)
	var right = Input.is_key_pressed(68)
	var jump = Input.is_action_just_released("ui_up")

	vel.y += gravity * delta
	var direction_x = int(right) - int(left)

	if direction_x == -1:
		vel.x = min(vel.x - acell, max_speed)
		$Animation.play("walk_left")
	elif direction_x == 1:
		vel.x = max(vel.x + acell, max_speed)
		$Animation.play("walk_right")
	else:
		vel.x = 0
		$Animation.play("Idle")
		
	if jump and is_on_floor():
		vel.y -= 200

	
	vel = move_and_slide(vel, scene_up)
