extends RigidBody3D
var velocity := 1000.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode

# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis
	horizon_basis  = horizon_basis * Basis.FLIP_X
	horizon_basis  = horizon_basis * Basis.FLIP_Z
	print(velocity)
	apply_central_force(Vector3(input.x, 0 ,input.y) * velocity * 1 * delta * horizon_basis)
	if Input.is_action_pressed("shift"):
		velocity = 00
	else:
		velocity = 1000
func _unhandled_input(event):  		
	if event is InputEventMouseMotion:#and Input.is_action_pressed("mouse_right"):
		mNode.rotate_y(deg_to_rad(event.relative.x*mouse_sens))
		hrzn.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		vert.rotate_z(deg_to_rad(-event.relative.y*0.3))
		vert.rotation.x = clamp(vert.rotation.x, deg_to_rad(-30.0), deg_to_rad(30.0))
