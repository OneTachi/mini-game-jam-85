extends KinematicBody2D

var SlashEffect = preload("res://Effects/SlashEffect.tscn")

onready var ray = $RayCast2D
onready var anim_tree = $AnimationTree
onready var dash_timer = $DashTimer
onready var attack_timer = $AttackTimer
onready var hit_rotation = $HitRotation
onready var hit_area = $HitRotation/Hitbox
const SPEED_X = 450
const SPEED_Y = 200

var in_air
var y_change = 0
var jump_limiter = 0
var input_vector
var x_movement = 0
var dash_amount = 4
var dashed = false

func _physics_process(delta):
	var x_input = Input.get_action_strength("right") - Input.get_action_strength("left")
	var y_input = Input.get_action_strength("down") - Input.get_action_strength("up")
	
	modify_input(x_input, y_input)
	
	if Input.is_action_just_pressed("dash"):
		dash(x_input)
	
	hit_area.monitoring = false
	if Input.is_action_just_pressed("attack"):
		attack(x_input, y_input)
	
	if in_air:
		input_vector = Vector2(x_input, y_change).normalized()
	else:
		input_vector = Vector2(x_input, 0).normalized()
	anim_tree.set("parameters/Movement/blend_position", input_vector)
	
	
	var move_vector = Vector2(x_movement, y_change)
	move_and_slide(Vector2(move_vector.x * SPEED_X, y_change * SPEED_Y))

func modify_input(x_input, y_input):
	if !dashed:
		y_change = clamp(y_change + .5, -6, 6)
	else:
		y_change = 0
	
	if x_input != 0 && dashed == false: 
		x_movement = clamp(x_movement + .2 * x_input, -1, 1)
	elif dashed == true:
		x_movement = clamp(x_movement + .2 * x_input, -3, 3)
	else:
		x_movement = 0
	
	if ray.is_colliding():
		jump_limiter = 0
		in_air = false
	else:
		in_air = true
	
	
	if y_input == -1 && jump_limiter < 6:
		y_change = y_change - 2.5
		jump_limiter += 1
	
	if y_input >=0:
		jump_limiter = 6
		#print(y_change)

func dash(x_input):
	if dash_amount > 0 && x_input != 0 && dashed == false:
		x_movement = 3 * x_input
		y_change = 0
		dash_timer.start(.2)
		dashed = true
		#dash_amount -= 1

func _on_DashTimer_timeout():
	dashed = false

func attack(x_input, y_input):
	if attack_timer.is_stopped():
		hit_area.monitoring = true
		var slasheffect = SlashEffect.instance()
		if x_input != 0:
			if x_input > 0:
				hit_rotation.rotation_degrees = 0
				get_parent().add_child(slasheffect)
				slasheffect.global_position = global_position + Vector2(50, 0)
				slasheffect.flip_h = true
			elif x_input < 0:
				hit_rotation.rotation_degrees = 180
				get_parent().add_child(slasheffect)
				slasheffect.global_position = global_position + Vector2(-50, 0)
		elif y_input != 0:
			if y_input > 0:
				hit_rotation.rotation_degrees = 90
				get_parent().add_child(slasheffect)
				slasheffect.global_position = global_position + Vector2(0, 50)
				slasheffect.rotation_degrees = -90
			elif y_input < 0:
				hit_rotation.rotation_degrees = -90
				get_parent().add_child(slasheffect)
				slasheffect.global_position = global_position + Vector2(0, -50)
				slasheffect.rotation_degrees = 90
		else:
			hit_area.monitoring = false
			slasheffect = null
		attack_timer.start(.3)


func _on_TopCheck_body_entered(body):
	y_change = 0
	jump_limiter = 6
