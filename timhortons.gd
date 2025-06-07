extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready():
	use_collision = false
	visible = false

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_target_hit():
	pass # Replace with function body.
	use_collision = true
	visible = true
