extends Sprite3D

func _process(delta):
	self.rotation.z = (GPlayerData.harvester_speed / 9.0) + PI * 0.25
