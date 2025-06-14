extends Area3D
var target_scene = preload("res://target.tscn").instantiate() 
@onready var target = target_scene.get_node("target")
@onready var targetList = ["target", "target2", "target3"]
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if body.get_name() in targetList:
		body.target_hit()
		get_parent().queue_free()
