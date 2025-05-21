extends RigidBody3D
signal veloSpeed
signal colF
signal colT
var vMultiplier := 1000.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode
@onready var velocity_label = $"Control/velocity"
var grounded = 0
var max_horizontal_speed := 3.0
var jumps = 2
@onready var rayCast = $v/h/S/Camera3D/RayCast3D
@onready var h = ($"v/h/S/Camera3D/RayCast3D/rayball").get_surface_override_material(0)
@onready var ball = $v/h/S/Camera3D/RayCast3D/rayball
@onready var rayEnd = $v/h/S/Camera3D/longRay/rayEnd
@onready var longRay = $v/h/S/Camera3D/longRay
var colliding = false
var launch = false
var launchWas = false
var inputVector = Vector3.ZERO
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	linear_damp = 1.0
	
var rope_dir = Vector3.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	#If you're in the air, fall faster.
	if linear_velocity.y <= -1.0:
		gravity_scale = 1.5
	else:
		gravity_scale = 1
		
	
	#Label for velocity
	veloSpeed.emit(linear_velocity)
	velocity_label.text = "Velocity: " + str(linear_velocity)
	
	
	#Code for my movement
	#===============================================================#
	var horizontal_velocity = Vector2(linear_velocity.x, linear_velocity.z)
	#Gets my movement (A,W,S,D or arrow keys)
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis #Check for nMode explanation (second line in unhandled input).)
	apply_central_force(inputVector * vMultiplier * 1 * delta * horizon_basis) #Apply movement
	if Input.is_action_pressed("shift"):
		max_horizontal_speed = 8.0
		vMultiplier = 4000
	else:
		max_horizontal_speed = lerp(max_horizontal_speed, 3.0, 0.1)
		vMultiplier = 2500
	#print(horizontal_velocity.length())
	#Limiting velocity:
	#print(horizon_basis)
	if launch == true:
		inputVector = Vector3( 0 , 0 ,input.y)
	elif launch == false and Input.is_action_pressed("shift"):
		inputVector = Vector3(input.x, 0 ,input.y)
		if horizontal_velocity.length() > 8.2:
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
			if linear_velocity.y > 10:
				linear_velocity.y = 9.9
	else:
		inputVector = Vector3(input.x, 0 ,input.y)
		if horizontal_velocity.length()> 3.1:
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
			if linear_velocity.y > 10:
				linear_velocity.y = 9.9
	col()

#This works
func col():
	if longRay.is_colliding():
		if rayCast.is_colliding():
			h.albedo_color = Color(0,1,0)
			var collision_point = rayCast.get_collision_point()
			ball.global_transform.origin = collision_point
			colliding = true
			emit_signal("colT")
		else:
			h.albedo_color = Color(1,0,0)
			var longRayCol = longRay.get_collision_point()
			ball.global_transform.origin = longRayCol
			colliding = false
			emit_signal("colF")
	else:
		h.albedo_color = Color(1,0,0)
		ball.global_transform.origin = rayEnd.global_transform.origin
		colliding = false
		emit_signal("colF")
		return colliding

#This works
func _unhandled_input(event):  		
	if event is InputEventMouseMotion: #My movement code
		mNode.rotate_y(deg_to_rad(event.relative.x*mouse_sens)) #moNode, meaning movement Node, ensures that my movement is going the right way (because the way your camera turns is the opposite way your character should move)
		hrzn.rotate_y(deg_to_rad(-event.relative.x*mouse_sens)) 
		vert.rotate_x(deg_to_rad(-event.relative.y*0.3))
		vert.rotation.x = clamp(vert.rotation.x, deg_to_rad(-90.0), deg_to_rad(60.0))
	if $feet.is_colliding():
		grounded = 1
		jumps = 2
		launch = false
	if Input.is_action_just_pressed("space"):
		if grounded == 1:
			if jumps == 2:
				apply_central_impulse(Vector3(0,1,0) * 15)
				jumps -=1
			elif jumps == 1:
				if linear_velocity.y <= 0.25:
					apply_central_impulse(Vector3(0, 1 ,0) * 20 )
					jumps -=1
			elif jumps == 0:
				grounded = 0


func _on_grapple_controller_launching():
	launch = true
	launchWas = true
	if jumps == 0:
		jumps += 1
	print(jumps)


func _on_grapple_controller_retracted():
	launchWas = false




