extends MeshInstance3D

@onready var collision = $StaticBody3D/CollisionShape3D
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_target_hit_2():
	visible = false
	collision.set_deferred("collision", false)



func _on_target_redo_2():
	visible = true
	collision.set_deferred("collision", true)
