extends Node2D

onready var nav = $Navigation2D
onready var goldy = $Goldy
onready var player = $Player
onready var line = $Line2D
onready var pos1 = $"Jump Positions/Jump1"

onready var positions = {"pos1" : $Positions/Position2D}
func _physics_process(delta):
	get_enemy_path()

func get_enemy_path():
	goldy.path = nav.get_simple_path(goldy.global_position, positions["pos1"].global_position, true)
	
	
	line.points = goldy.path
