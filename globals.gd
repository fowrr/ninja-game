extends Node

@onready var current_level = 10
@onready var level_passed = null 
@onready var level_passedInt = null
var win = false
var next_level = null
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func gem_0():
	level_passedInt = 9
	level_passed = "the tutorial"
	next_level = ("res://level_1.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt
		
func gem_1():
	level_passedInt = 8
	level_passed = "level 1"
	next_level = ("res://level_2.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt
