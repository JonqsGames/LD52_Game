extends Node
# GLOBAL
const WAVE_DURATION = 30 # seconds
const SHOP_DURATION = 60 # seconds

const SPEED_UP_MULTIPLICATOR = 12.0

enum GameStatus {
	WAVE,
	SHOP
}
# Time Control
var timer = 0.0
var time_multiplicator = 1.0
# Wave data
var harvested_mob = 0
var status : GameStatus = GameStatus.SHOP

signal game_wave_done()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start_shopping()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_pressed("speed_up"):
		print("[PlayerData] SPEED UP")
		self.time_multiplicator = SPEED_UP_MULTIPLICATOR
	else:
		self.time_multiplicator = 1.0
	match status:
		GameStatus.WAVE:
			timer -= delta
			if timer <= 0:
				self.end_wave()
		GameStatus.SHOP:
			timer -= delta * self.time_multiplicator
			if timer <= 0:
				self.start_wave()
	
func start_wave():
	harvested_mob = 0
	timer = WAVE_DURATION
	status = GameStatus.WAVE

func start_shopping():
	timer = SHOP_DURATION
	status = GameStatus.SHOP

func end_wave():
	game_wave_done.emit()
	self.start_shopping()
	
func is_wave_running():
	return self.status == GameStatus.WAVE
	
func mob_harvested():
	print("[PlayerData] Harvested mob")
	self.harvested_mob += 1
	
	
	
