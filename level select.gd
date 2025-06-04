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

@onready var current_levels = [ten,nine,eight,seven,six,five,four,three,two,one]
@onready var all_levels = [ten,nine,eight,seven,six,five,four,three,two,one]
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	for level in all_levels:
		if level in current_levels:
			level.disabled = true
		else:
			level.disabled = false
			
	if Globals.current_level != len(current_levels):
		change()
func change():
	print(Globals.current_level)
	print(len(current_levels))
	current_levels.pop_at(-1)
	print(current_levels)


func _on__pressed():
	pass # Replace with function body.
