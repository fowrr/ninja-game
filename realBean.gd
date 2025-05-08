extends CharacterBody3D
signal Velocity
@onready var hrzn = $h
@onready var vert = $h/v
@onready var b = $b
var mouse_sens = 0.3
const SPEED = 5.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	var b_basis = b.get_basis()
	# Handle Jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (b_basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, 0.33)
		velocity.z = move_toward(velocity.z, 0, 0.33)
	move_and_slide()
func _unhandled_input(event):  		
	if event is InputEventMouseMotion:#and Input.is_action_pressed("mouse_right"):
		hrzn.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		b.rotate_y(deg_to_rad(-event.relative.x*mouse_sens))
		vert.rotate_x(deg_to_rad(-event.relative.y*0.3))
		vert.rotation.x = clamp(vert.rotation.x, deg_to_rad(-30.0), deg_to_rad(30.0))
