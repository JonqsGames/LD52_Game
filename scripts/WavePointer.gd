extends Sprite3D

func _process(delta):
	if GPlayerData.status == GPlayerData.GameStatus.SHOP:
		var rate = GPlayerData.timer / GPlayerData.SHOP_DURATION
		self.rotation.z = rate * PI - PI * 0.5
	else:
		var rate = GPlayerData.timer / GPlayerData.WAVE_DURATION
		self.rotation.z = rate * PI + PI * 0.5
		
