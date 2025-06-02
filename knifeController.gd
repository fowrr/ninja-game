extends Node3D	
signal sensChange
signal sensChange2
var knifeAvailable = false
@onready var zoom = $"../Control/zoom"
@onready var camera = $"../v/h/Camera3D"
@onready var pos = $"../v/h/knifePos"
var knife_proj = preload("res://knife_proj.tscn").instantiate() 
#@onready var 
#@onready var 
#@onready var 
# Called when the node enters the scene tree for the first time.
func _ready():
	zoom.visible = false


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if knifeAvailable == false:
		if Input.is_action_pressed("zoom"):
			zoom.visible = true
			camera.fov = 32.5
			emit_signal("sensChange")
		if Input.is_action_just_released("zoom"):
			zoom.visible = false
			camera.fov = 75
			emit_signal("sensChange2")
		if Input.is_action_just_pressed("shoot"):
			shoot()
func shoot():
	knife_proj.position = pos.global_position
	knife_proj.transform.basis = pos.global_transform.basis
	get_parent().add_child(knife_proj)

func _on_bean_grapple_1():
	knifeAvailable = false


func _on_bean_knife_1():
	knifeAvailable = true
