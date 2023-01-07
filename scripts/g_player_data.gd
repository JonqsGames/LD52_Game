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

var is_in_shop = false

signal game_wave_done()
signal game_wave_start()
signal game_enter_shop()
signal game_leave_shop()

# Called when the node enters the scene tree for the first time.
func _ready():
	self.start_shopping()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if self.is_in_shop:
		if Input.is_action_just_pressed("leave_shop"):
			self.leave_shop()
	else:
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
	self.game_wave_start.emit()

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
	
func activate_shop():
	print("[PlayerData] Shop entered")
	self.game_enter_shop.emit()
	is_in_shop = true

func leave_shop():
	print("[PlayerData] Shop leaved")
	is_in_shop = false
	self.game_leave_shop.emit()
