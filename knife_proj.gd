extends RayCast3D
#https://www.youtube.com/watch?v=vGpFwaLUG4U&ab_channel=Bramwell
#https://www.youtube.com/watch?v=vGpFwaLUG4U&ab_channel=Bramwell
#https://www.youtube.com/watch?v=vGpFwaLUG4U&ab_channel=Bramwell
@export var speed := 5.0
 
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += transform.basis * Vector3.UP * delta * speed
	#target_position = Vector3.FORWARD * speed * delta
	force_raycast_update()
	var collider = get_collider()
	if is_colliding():
		global_position = get_collision_point()
		set_physics_process(false)

func cleanup():
	queue_free()
