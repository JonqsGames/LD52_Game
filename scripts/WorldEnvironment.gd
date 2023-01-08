extends WorldEnvironment
@export var cycle_curve : Curve
@export_group("Day Props")
@export var ambient_light_day : Color
@export var sky_top_day : Color
@export var sky_hor_day : Color
@export var sky_ground_day : Color
@export_group("Night Props")
@export var ambient_light_night : Color
@export var sky_top_night : Color
@export var sky_hor_night : Color
@export var sky_ground_night : Color

func _process(delta):
	if GPlayerData.status == GPlayerData.GameStatus.SHOP:
		var rate = GPlayerData.timer / GPlayerData.SHOP_DURATION
		rate = cycle_curve.sample(1.0 - rate)
		self.environment.ambient_light_color = ambient_light_day.lerp(ambient_light_night, rate)
		self.environment.sky.sky_material.sky_top_color = sky_top_day.lerp(sky_top_night, rate)
		self.environment.sky.sky_material.sky_horizon_color = sky_hor_day.lerp(sky_hor_night, rate)
		self.environment.sky.sky_material.ground_horizon_color = sky_hor_day.lerp(sky_hor_night, rate)
		self.environment.sky.sky_material.ground_bottom_color = sky_ground_day.lerp(sky_ground_night, rate)
	else:
		var rate = GPlayerData.timer / GPlayerData.WAVE_DURATION
		rate = cycle_curve.sample(1.0 - rate) 
		self.environment.ambient_light_color = ambient_light_night.lerp(ambient_light_day, rate)
		self.environment.sky.sky_material.sky_top_color = sky_top_night.lerp(sky_top_day, rate)
		self.environment.sky.sky_material.sky_horizon_color = sky_hor_night.lerp(sky_hor_day, rate)
		self.environment.sky.sky_material.ground_horizon_color = sky_hor_night.lerp(sky_hor_day, rate)
		self.environment.sky.sky_material.ground_bottom_color = sky_ground_night.lerp(sky_ground_day, rate)
