extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if get_parent().visible == false:
		use_collision = false
	else:
		use_collision = true


func _on_target_target_hit():
	get_parent().visible = true
