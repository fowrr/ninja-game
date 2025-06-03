extends Area3D
var player_scene = preload("res://bean2.tscn").instantiate() 
@onready var grapLogo = player_scene.get_node("Slots/grappler")

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_name() == "bean":
		body.knife_visibilty()
		queue_free()
