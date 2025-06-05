extends Node3D

@onready var collision = $"MeshInstance3D/StaticBody3D/CollisionShape3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	collision.set_deferred("disabled", true)
	visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_2_redo_2():
	visible = false
	collision.set_deferred("disabled", true)

func _on_target_2_target_hit_2():
	visible = true
	collision.set_deferred("disabled", false)
