extends RigidBody3D
signal veloSpeed
var velocity := 1000.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode
@onready var velocity_label = $"Control/velocity"
var grounded = 0
var max_horizontal_speed := 4.0
var jumps = 2
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	linear_damp = 1.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	print(grounded)
	
	
	var speed = get_linear_velocity()	
	if abs(linear_velocity.x) > max_horizontal_speed:
		linear_velocity.x = sign(linear_velocity.x) * max_horizontal_speed
	if abs(linear_velocity.z) > max_horizontal_speed:
		linear_velocity.z = sign(linear_velocity.z) * max_horizontal_speed
	veloSpeed.emit(speed)
	velocity_label.text = "Velocity: " + str(speed)
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis
	apply_central_force(Vector3(input.x, 0 ,input.y) * velocity * 1 * delta * horizon_basis)
	if Input.is_action_pressed("shift"):
		velocity = 2500
		max_horizontal_speed = 6.0
	else:
		velocity = 1000
		max_horizontal_speed = 3.0
func _unhandled_input(event):  		
	if event is InputEventMouseMotion:#and Input.is_action_pressed("mouse_right"):
		mNode.rotate_y(deg_to_rad(event.relative.x*mouse_sens))
		hrzn.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		vert.rotate_x(deg_to_rad(-event.relative.y*0.3))
		vert.rotation.x = clamp(vert.rotation.x, deg_to_rad(-90.0), deg_to_rad(60.0))
	if $feet.is_colliding():
		grounded = 1
		jumps = 2
	if Input.is_action_just_pressed("space"):
		if grounded == 1:
			apply_central_impulse(Vector3(0, 1 ,0) * 6 )
			jumps -=1
			if jumps == 0:
				grounded = 0
