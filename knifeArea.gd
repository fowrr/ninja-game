extends Area3D
var target_scene = preload("res://target.tscn").instantiate() 
@onready var target = target_scene.get_node("target")
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_name() == "target":
		body.target_hit()
