class_name SchoolFish extends RigidBody2D

func init_with(pos_offset: Vector2):
	position += pos_offset
	return self
