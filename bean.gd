extends RigidBody3D
signal veloSpeed
signal colF
signal colT
signal Grapple1
signal Knife1
signal voidTutTrigger
signal barrier
signal pausedTrue
signal pausedFalse
var vMultiplier := 1000.0
var mouse_sens = 0.3
@onready var hrzn = $v
@onready var vert = $v/h
@onready var mNode = $movementNode
@onready var velocity_label = $"Control/velocity"
var grounded = 0
var max_speed := 3.0
var jumps = 2
@onready var rayCast = $v/h/Camera3D/RayCast3D
@onready var h = ($"v/h/Camera3D/RayCast3D/rayball").get_surface_override_material(0)
@onready var ball = $v/h/Camera3D/RayCast3D/rayball
@onready var rayEnd = $v/h/Camera3D/longRay/rayEnd
@onready var longRay = $v/h/Camera3D/longRay
@onready var grapLogo = $Slots/grappler
@onready var knifeLogo = $Slots/knife
var colliding = false
var launch = false
var launchChain = false
var inputVector = Vector3.ZERO
var input = Vector3.ZERO
var horizontal_velocity = Vector2.ZERO
var rope_dir = Vector3.ZERO
var torque_axis = null
@onready var plunger = $v/h/grapple2/Plunger
@onready var gunPlunger = $v/h/grapple2/Tinker
@onready var knife = $v/h/knife/knife
@onready var knifeRay = $"v/h/Camera3D/knife ray"
@onready var initial_pos = global_position
@onready var crosshair = $v/h/Camera3D/HBoxContainer/crosshair
@onready var pausedScreen = $Control/pause
@onready var dialogue = $Control/dialogueBox/dialogue
@onready var winGUI = $Control/win
@onready var winLabel = $Control/win/winLabel
var plungerUse = 0
var knifeUse = 0
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready():
	crosshair.visible = false
	print(initial_pos)
	grapLogo.visible = false
	knifeLogo.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	linear_damp = 1.0
	gunPlunger.visible = false
	plunger.visible = false
	knife.visible = false
	ball.visible = false
	$Control/dialogueBox.visible = false
	paused = false
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
	
	horizontal_velocity = Vector2(linear_velocity.x, linear_velocity.z)
	#Code for my movement
	#===============================================================#
	
	#Gets my movement (A,W,S,D or arrow keys)
	input = Input.get_vector("ui_left","ui_right","ui_up","ui_down")
	var horizon_basis = mNode.basis #Check for nMode explanation (second line in unhandled input).
	if paused == false:
		apply_central_force(inputVector * vMultiplier * 1 * delta * horizon_basis) #Apply movement
	if Input.is_action_pressed("shift") and launchChain == false:
		max_speed = 8.0
		vMultiplier = 4000
	elif launchChain == false:
		max_speed = lerp(max_speed, 4.0, 0.5)
		vMultiplier = 2500

	if input == Vector2.ZERO and colliding == true:
		max_speed = lerp(max_speed, 0.0, 0.1)
	
	
	if Globals.win == false:
		if Input.is_action_just_pressed("pause"):
			if paused == true:
				paused = false
				emit_signal("pausedFalse")
				pausedScreen.visible = false
			elif paused == false:
				paused = true
				emit_signal("pausedTrue")
				pausedScreen.visible = true
	if paused == false:
		pausedScreen.visible = false
		
		
	#To process my items and when i can use them and what not
	if plungerUse == 0:
		pass
	elif plungerUse == 1:
		if Input.is_action_just_pressed("1"):
			crosshair.visible = true
			plunger.visible = true
			ball.visible = true
			gunPlunger.visible = true
			knife.visible = false
			emit_signal("Grapple1")
	if knifeUse == 0:
		pass
	elif knifeUse == 1:
		crosshair.visible = true
		ball.visible = true
		if Input.is_action_just_pressed("2"):
			emit_signal("Knife1")
			plunger.visible = false
			gunPlunger.visible = false
			knife.visible = true
	if plunger.visible == true:
		col()
	elif knife.visible == true:
		colK()
	if Globals.win == true:
		winGUI.visible = true
		winLabel.text = "You passed " + str(Globals.level_passed) +("!")
	elif Globals.win == false:
		winGUI.visible = false
	#print(launchChain)
	#print(rope_dir)
	
func colK():
	if knifeRay.is_colliding():
		h.albedo_color = Color(0,1,0)
		var collision_point = rayCast.get_collision_point()
		ball.global_transform.origin = collision_point
		colliding = true
		emit_signal("colT")
	else:
		h.albedo_color = Color(1,0,0)
		ball.global_transform.origin = rayEnd.global_transform.origin
		colliding = false
		emit_signal("colF")
		return colliding
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
func _input(event): 
	if paused == true or Globals.win == true:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		freeze = true
	elif paused == false or Globals.win == false:
		freeze = false
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		if event is InputEventMouseMotion: #My movement code
			mNode.rotate_y(deg_to_rad(event.relative.x*mouse_sens)) #moNode, meaning movement Node, ensures that my movement is going the right way (because the way your camera turns is the opposite way your character should move)
			hrzn.rotate_y(deg_to_rad(-event.relative.x*mouse_sens)) 
			vert.rotate_x(deg_to_rad(-event.relative.y*mouse_sens))
			vert.rotation.x = clamp(vert.rotation.x, deg_to_rad(-90.0), deg_to_rad(60.0))
		if $feet.is_colliding():
			grounded = 1
			jumps = 2
			launchChain = false
		if Input.is_action_just_pressed("space"):
			if grounded == 1:
				if jumps == 2:
					apply_central_impulse(Vector3.UP * 15)
					jumps -=1
				elif jumps == 1:
					if linear_velocity.y <= 1.0:
						apply_central_impulse(Vector3.UP * 15 )
						jumps -=1

func _integrate_forces(state):
	if launch == true:
		inputVector = Vector3( 0 , 0 ,input.y)
		#var tangent_dir = (inputVector - inputVector.dot(rope_dir) * rope_dir).normalized()
		torque_axis = rope_dir.cross(inputVector).normalized()
		apply_torque_impulse(torque_axis * 50)
	elif launchChain == true and launch == false:
		torque_axis = null
		inputVector = Vector3( input.x , 0 ,input.y)
		if horizontal_velocity.length() >= 10.0:
			vMultiplier = lerp(vMultiplier, 1000.00, 0.5)
		elif horizontal_velocity.length() > 8.1:
			print("bruhbruh")
			vMultiplier = 2000
			horizontal_velocity = horizontal_velocity.normalized() * 8
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
	elif launch == false and launchChain == false and Input.is_action_pressed("shift"):
		inputVector = Vector3(input.x, 0 ,input.y)
		if horizontal_velocity.length() > 8.2:
			horizontal_velocity = horizontal_velocity.normalized() * max_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
			if linear_velocity.y > 15.1:
				linear_velocity.y = 15
	else:
		inputVector = Vector3(input.x, 0 ,input.y)
		if horizontal_velocity.length()> 4.1:
			horizontal_velocity = horizontal_velocity.normalized() * max_speed
			linear_velocity = Vector3(horizontal_velocity.x,linear_velocity.y,horizontal_velocity.y)
			if linear_velocity.y > 15.1:
				linear_velocity.y = 15

func _on_grapple_controller_launching():
	launch = true
	plunger.visible = false
	launchChain = true
	if jumps == 0:
		jumps += 1
	print(jumps)


func _on_grapple_controller_retracted():
	launch = false
	plunger.visible = true
	rope_dir = null
	vMultiplier = 5000


func _on_grapple_controller_point(dir_player_targ):
	rope_dir = dir_player_targ
 

func _on_void_body_entered(body):
	if "bean" == body.get_name():
		global_position = initial_pos

func grapple_visibilty():
	grapLogo.visible = true
	plungerUse = 1
func knife_visibilty():
	knifeLogo.visible = true
	knifeUse = 1


func _on_knife_controller_sens_change():
	mouse_sens = 0.05


func _on_knife_controller_sens_change_2():
	mouse_sens = 0.3

#Dialogues
func _on_tutorial_trigger_body_entered(body):
	if body.get_name() == "bean":
		emit_signal("voidTutTrigger")
		$Control/dialogueBox.visible = true
		dialogue.text = "Hello."
		await get_tree().create_timer(3.0).timeout
		dialogue.text = "You're probably wondering who I am." 
		await get_tree().create_timer(5.0).timeout
		dialogue.text = "I am Mr. Nemeth, and I'm talking directly to your subconcious"
		await get_tree().create_timer(4.0).timeout
		dialogue.text = "Listen, I need you to collect gems for me."
		await get_tree().create_timer(5.0).timeout
		dialogue.text = "There should be an image on how it should look like."
		await get_tree().create_timer(4.0).timeout
		dialogue.text = "I've left more signs around on this level, to teach you more about this game."
		await get_tree().create_timer(5.0).timeout
		dialogue.text = "Good luck, I need those gems to get friday morning goodies."
		await get_tree().create_timer(4.0).timeout
		$Control/dialogueBox.visible = false
		emit_signal("barrier")
	


func _on_resume_pressed():
	paused = false




func _on_next_pressed():
	Globals.win = false
	get_tree().change_scene_to_file(Globals.next_level)
