extends Node3D
signal launching
signal retracted
#This whole code will the grappling code
#I will attempt to make a 3D version of the springJoint that the 2D space has.
var colliding = false
@export var RayCast: RayCast3D
@onready var ray = $"../v/h/Camera3D/RayCast3D"
@export var stiffness := 20.0
@export var rest_length := 5.0
@export var damping := 1.0
@onready var player = get_parent()

func _ready():
	pass # Replace with function body.

var launched = false
var hook_target = Vector3.ZERO
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("shoot") and colliding == true:
		launch()
		emit_signal("launching")
	if Input.is_action_just_released("shoot"):
		retract()
		emit_signal("retracted")
	if launched == true:
		grapple_physics(delta)

func retract():
	launched = false

func launch():
	hook_target = ray.get_collision_point()
	launched = true

func grapple_physics(delta):
	var dir_player_targ = player.global_position.direction_to(hook_target)
	var dist_player_targ = player.global_position.distance_to(hook_target)
	

	var force = Vector3.ZERO
	var displacement = dist_player_targ - rest_length  #Springy part. If the distance is more than it should be,
	#our player will move towards what it should be(rest length). Else, gravity will take care of it.
	if displacement > 0:
		#var spring_force_mag = stiffness * displacement #force of our spring springing back, higher stiffness = 
		#var spring_force = spring_force_mag * dir_player_targ # more harder to spring in the first place, which is what i'm going for. This line makes sure that we're springing back to the
																#target.
		var vel_dot = player.linear_velocity.dot(dir_player_targ) 
		var damp = -damping * vel_dot * dir_player_targ
		force = stiffness * displacement * dir_player_targ + damp
	player.apply_central_force(force)
func _on_bean_col_t():
	colliding = true


func _on_bean_col_f():
	colliding = false
