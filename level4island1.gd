extends Node3D

@onready var collision = $"MeshInstance3D/StaticBody3D/CollisionShape3D"
# Called when the node enters the scene tree for the first time.
func _ready():
	visible = false
	collision.set_deferred("disabled", true)
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_target_target_hit_1():
	visible = true
	collision.set_deferred("disabled", false)


func _on_target_redo_1():
	visible = false
	collision.set_deferred("disabled", true)
