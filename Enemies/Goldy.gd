extends KinematicBody2D

onready var nav = $"../Navigation2D"
onready var ground_check = $GroundCheck
onready var sprite = $AnimatedSprite
onready var plat_check = $PlatformCheck
onready var flight_timer = $FlightTimer

const max_velocity = 200
const gravity = 200
const max_jump = -5
const gravity_interpolation = 0.05

var path setget set_path

var velocity = 200
var path_number = 0
var fall = 0 
var direction


func _physics_process(delta):
	move(delta)


func set_path(value):
	path = value
	path_number = 0

func move(delta):
	#Prerequisites
	if path == null:
		return
	if path_number == path.size() - 1:
		return
	
	
	if position.distance_to(path[path_number]) <= 20:
		path_number += 1 
	direction = global_position.direction_to(path[path_number]) * velocity
	
	#Manipulating Gravity
	fall = clamp(fall + 30, -1000, 1000)
	if is_on_ceiling() and fall < 0:
		fall = 0
	
	if global_position.direction_to(path[path_number]).y < -.8 and ground_check.is_colliding():
		fall = jump()
	
	flip_sprite()
	move_and_slide(Vector2(direction.x, fall), Vector2.UP)

func jump():
	return max_jump * velocity

func flip_sprite():
	if direction.x > 0: 
		sprite.flip_h = true
	else: 
		sprite.flip_h = false


