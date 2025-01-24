extends PathFollow2D

var current: Current = null

var movement_speed = 50.0
var accel_ratio = 3.0
var accel = 0.0

@onready var remote_transform = $RemoteTransform2D
var follower: Node2D

func init_with(p_current: Current):
	current = p_current

func set_follower(p_follower: Node2D):
	follower = p_follower

func _ready():
	if follower:
		remote_transform.remote_path = follower.get_path()
		# Set appopriate progress
		var offset = current.get_object_nearest_point_offset(follower)
		set_progress(offset)

func _physics_process(delta):
	set_progress(get_progress() + movement_speed * delta + accel)
	accel += accel_ratio * delta