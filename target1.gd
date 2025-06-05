extends CSGBox3D
signal targetHit2
signal redo2


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
func target_hit():
	emit_signal("targetHit2")
	visible = false
	use_collision = false
	await get_tree().create_timer(2.0).timeout
	emit_signal("redo2")
	visible = true
	use_collision = true
