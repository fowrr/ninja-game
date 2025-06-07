extends CSGBox3D


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_target_hit_2():
	get_parent().visible = true


func _on_target_redo_2():
	get_parent().visible = true
