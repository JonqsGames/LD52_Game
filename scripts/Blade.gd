extends Node3D

const ROT_SPEED = -25.0

func _process(delta):
	self.rotate_x(ROT_SPEED * delta * self.get_parent().get_parent().turning_speed)
