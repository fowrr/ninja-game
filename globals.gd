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
	level_passed = "You passed the tutorial!"
	next_level = ("res://level_1.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt
		
func gem_1():
	level_passedInt = 8
	level_passed = "You passed level 1!"
	next_level = ("res://level_2.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_2():
	level_passedInt = 7
	level_passed = "You passed level 2!"
	next_level = ("res://level_3.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_3():
	level_passedInt = 6
	level_passed = "You passed level 3!"
	next_level = ("res://level_4.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_4():
	level_passedInt = 5
	level_passed = "You passed level 4!"
	next_level = ("res://level_5.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_5():
	level_passedInt = 4
	level_passed = "You passed level 5!"
	next_level = ("res://level_6.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_6():
	level_passedInt = 3
	level_passed = "You passed level 6!"
	next_level = ("res://level_7.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_7():
	level_passedInt = 3
	level_passed = "You passed level 7!"
	next_level = ("res://level_8.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_8():
	level_passedInt = 2
	level_passed = "You passed level 8!"
	next_level = ("res://level_9.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt
		
func gem_9():
	level_passedInt = 1
	level_passed = "You passed level 9!"
	next_level = ("res://level_10.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt

func gem_10():
	level_passedInt = 0
	level_passed = "You passed level 10!"
	next_level = ("res://credits.tscn")
	win = true
	if current_level >= level_passedInt:
		current_level  = level_passedInt
