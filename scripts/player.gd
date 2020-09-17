extends KinematicBody2D

const max_speed = 150
const acell = 10
const gravity =300
var   vel:Vector2 = Vector2()
var   scene_up:Vector2 = Vector2(0, -1)
var   anim
var state_machine
var last_direction:String = "_right"

func _ready():
	state_machine = $AnimationTree.get("parameters/playback")

func _physics_process(delta) -> void:
	var left  = Input.is_key_pressed(65)
	var right = Input.is_key_pressed(68)
	
	vel.y += gravity * delta

	var direction = int(right) - int(left)
	animate(direction)
	
	if direction == -1:
		vel.x = min(vel.x - acell, max_speed)
	elif direction == 1:
		vel.x = max(vel.x + acell, max_speed)
	else:
		vel.x = 0

	vel = move_and_slide(vel, scene_up)

func _input(event):
	var just_pressed = event.is_pressed() and not event.is_echo()
	if (Input.is_key_pressed(32) and just_pressed) and is_on_floor():
		vel.y -= 200

func animate(direction):	
	if is_on_floor() and direction == 0:
		anim = "idle"
	elif is_on_floor():
		anim = "walk"
	else:
		if vel.y < 0:
			anim = "jump"
		elif vel.y > 0:
			anim = "fall"
			
	if direction == 1:
		anim += "_right"
		last_direction = "_right"
	elif direction == -1:
		anim += "_left"
		last_direction = "_left"
		
	if(direction == 0):
		anim += last_direction
		
	if Input.is_key_pressed(KEY_Q):
		anim = "attack" + last_direction
				
	state_machine.travel(anim)
