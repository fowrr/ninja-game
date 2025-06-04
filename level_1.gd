extends Node3D

@onready var door = $door/AnimationPlayer
# Called when the node enters the scene tree for the first time.
func _ready():
	Globals.win = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_target_hit():
	door.play("open")
