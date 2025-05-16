extends RigidBody3D
signal veloSpeed
signal colF
signal colT
var velocity := 2500.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode
@onready var velocity_label = $"Control/velocity"
var grounded = 0
var max_horizontal_speed := 2.0
var max_diagonal_speed := 2.82842712475
var jumps = 2
@onready var rayCast = $v/h/S/Camera3D/RayCast3D
@onready var h = ($"v/h/S/Camera3D/RayCast3D/rayball").get_surface_override_material(0)
@onready var ball = $v/h/S/Camera3D/RayCast3D/rayball
@onready var rayEnd = $v/h/S/Camera3D/longRay/rayEnd
@onready var longRay = $v/h/S/Camera3D/longRay
var colliding = false
var launch = false
var launchWas = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	linear_damp = 1.0
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var horizontal_velocity = Vector2(linear_velocity.x, linear_velocity.z)
	#print(rayCast.transform.basis)
	#Code making sure my velocity is never higher than my max speed.
	#===============================================================#
	var current_velocity = linear_velocity # Get the current velocity of the rigid body
	if launch == true and launchWas == true:
		velocity = 2500
		max_horizontal_speed = 10.0
		if horizontal_velocity.length()> 11:
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
		#print(current_velocity.length())
	elif Input.is_action_pressed("shift") and grounded == 1:
		velocity = 2500
		max_horizontal_speed = 6.0
		if horizontal_velocity.length()> 7:
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y) #This code make sure my speed is capped if I'm sprinting
		#print(current_velocity.length())
	else:
		max_horizontal_speed = 2.0
		if horizontal_velocity.length()> 3: #Same gist as the code above, just now it's when my speed is normal (i.e. not sprinting).
			horizontal_velocity = horizontal_velocity.normalized() * max_horizontal_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
	#print(current_velocity.length())
	if linear_velocity.y <= -1.5:
		gravity_scale = 1
	else:
		gravity_scale = 1
		

	#Label for velocity
	veloSpeed.emit(current_velocity)
	velocity_label.text = "Velocity: " + str(current_velocity)
	
	#Gets my movement (A,W,S,D or arrow keys)
	var input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis #Check for nMode explanation (second line in unhandled input).
	var grappleBasis = vert.basis
	grappleBasis = Basis(Vector3(0,0,0), Vector3(0,0,0), Vector3(grappleBasis.x.z, grappleBasis.y.z, grappleBasis.z.z))
	if launch == false:
		apply_central_force(Vector3(input.x, 0 ,input.y) * velocity * 1 * delta * horizon_basis)
	elif launch == true:
		apply_central_force(Vector3(input.x, 0 ,0) * velocity * 1 * delta * grappleBasis)
	print(grappleBasis)
	#hi
	col()
	
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
				apply_central_impulse(Vector3(0, 1 ,0) * 7 )
				jumps -=1
			elif jumps == 1:
				if linear_velocity.y <= 0.25:
					apply_central_impulse(Vector3(0, 1 ,0) * 10 )
					jumps -=1
			elif jumps == 0:
				grounded = 0


func _on_grapple_controller_launching():
	launch = true
	launchWas = true


func _on_grapple_controller_retracted():
	launchWas = false



