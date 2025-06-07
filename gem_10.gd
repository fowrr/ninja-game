extends Area3D

var target = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_body_entered(body):
	if target == true:
		if body.get_name() == "bean":
			Globals.gem_10() #handles current level 
			Globals.win = true
			queue_free()



func _on_target_target_hit():
	target = true
	visible = true
