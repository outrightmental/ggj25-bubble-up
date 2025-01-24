extends PathFollow2D

@onready var remote_transform = $RemoteTransform2D
var follower: NodePath

func set_follower(path: NodePath):
	follower = path

func _ready():
	remote_transform.remote_path = follower