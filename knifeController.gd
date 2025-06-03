extends Node3D	
signal sensChange
signal sensChange2
var knifeAvailable = false
@onready var zoom = $"../zoom"
@onready var camera = $"../v/h/Camera3D"
@onready var pos = $"../v/h/knifePos"
var knife_proj = load("res://knife_proj.tscn")
@onready var bean = $".."
@onready var knifeTimer = $Timer
@onready var knife =  $"../v/h/knife"
@onready var crosshair = $"../v/h/Camera3D/CanvasLayer/HBoxContainer/crosshair"
@onready var crosshair2 = $"../v/h/Camera3D/CanvasLayer2/HBoxContainer/crosshair2"
#@onready var 
#@onready var 
# Called when the node enters the scene tree for the first time.
func _ready():
	zoom.visible = false
	crosshair2.visible = false
	crosshair.visible = true
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if knifeAvailable == true:
		if knifeTimer.is_stopped():
			knife.visible = true
			if Input.is_action_pressed("zoom"):
				crosshair2.visible = true
				crosshair.visible = false
				zoom.visible = true
				camera.fov = 32.5
				emit_signal("sensChange")
			if Input.is_action_just_released("zoom"):
				crosshair2.visible = false
				crosshair.visible = true
				zoom.visible = false
				camera.fov = 75
				emit_signal("sensChange2")
			if Input.is_action_just_pressed("shoot"):
				shoot()
				crosshair2.visible = false
				crosshair.visible = true
				camera.fov = 75
				emit_signal("sensChange2")
				knife.visible = false
				zoom.visible = false
				knifeTimer.start()
func shoot():
	var instance = knife_proj.instantiate()
	instance.position = pos.global_position
	instance.transform.basis = pos.global_transform.basis 
	get_tree().current_scene.add_child(instance)
func _on_bean_grapple_1():
	knifeAvailable = false


func _on_bean_knife_1():
	knifeAvailable = true
