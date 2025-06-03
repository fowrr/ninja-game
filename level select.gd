extends Control
@onready var zero = $"0"
@onready var one = $"1"
@onready var two = $"2"
@onready var three = $"3"
@onready var four = $"4"
@onready var five = $"5"
@onready var six = $"6"
@onready var seven = $"7"
@onready var eight = $"8"
@onready var nine = $"9"
@onready var ten = $"10"

@onready var current_level = [ten,nine,eight,seven,six,five,four,three,two,one]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for level in current_level:
		level.disabled = true

