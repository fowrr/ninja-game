extends RigidBody3D
signal veloSpeed
var velocity := 1000.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode
@onready var velocity_label = $"Control/velocity"
var grounded = 0
var max_horizontal_speed := 2.0
var max_diagonal_speed := 2.82842712475
var jumps = 2
var linear_v := 0.0000
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	linear_damp = 1.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	#Code making sure my velocity is never higher than my max speed.
	var current_velocity = linear_velocity # Get the current velocity of the rigid body
	if current_velocity.length() > max_horizontal_speed:
		current_velocity = current_velocity.normalized() * max_horizontal_speed
		linear_velocity = current_velocity
	print(linear_velocity.length())
	
	
	#Label for velocity
	veloSpeed.emit(current_velocity)
	velocity_label.text = "Velocity: " + str(current_velocity)
	
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis
	apply_central_force(Vector3(input.x, 0 ,input.y) * velocity * 1 * delta * horizon_basis)
	
	
	if Input.is_action_pressed("shift"):
		velocity = 2500
		max_horizontal_speed = 6.0
	else:
		velocity = 1000
		#max_horizontal_speed = 3.0
		
		
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
			if jumps == 2:
				apply_central_impulse(Vector3(0, 1 ,0) * 6 )
				jumps -=1
			elif jumps == 1:
				if linear_velocity.y <= 0:
					apply_central_impulse(Vector3(0, 1 ,0) * 6 )
					jumps -=1
			elif jumps == 0:
				grounded = 0
