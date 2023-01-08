extends Node
# GLOBAL
const WAVE_DURATION = 30 # seconds
const SHOP_DURATION = 30 #60 # seconds

const SPEED_UP_MULTIPLICATOR = 12.0

const START_LIFE_AMOUNT = 100

enum GameStatus {
	WAVE,
	SHOP,
	LOST
}
# Time Control
var timer = 0.0
var time_multiplicator = 1.0
# Wave data
var harvested_mob = 0
var harvested_mob_total = 0
var status : GameStatus = GameStatus.SHOP

var wave_counter = 0

var life = START_LIFE_AMOUNT
var is_in_shop = false
var harvester_speed = 0

var stats = {
	"reel_length" : 0.75,
	"speed_mult" : 1.0,
	"steering_mult": 1.3
}
var bonus_buyed = {}

signal game_wave_done()
signal game_wave_start()

signal game_enter_shop()
signal game_leave_shop()

signal game_end_lost()

signal game_augment_buyed(augment_data : Augment)

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
			self.time_multiplicator = SPEED_UP_MULTIPLICATOR
		else:
			self.time_multiplicator = 1.0
	match status:
		GameStatus.WAVE:
			timer -= delta
			if timer <= 0:
				self.end_wave()
		GameStatus.SHOP:
			if !is_in_shop:
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
	wave_counter += 1
	self.start_shopping()
	
func is_wave_running():
	return self.status == GameStatus.WAVE
	
func is_locked():
	return self.status == GameStatus.LOST or self.is_in_shop
	
func attack(dmg : float):
	self.life -= dmg
	if self.life <= 0:
		self.barn_door_destroyed()

func buy_augment(augment_data : Augment):
	var price_multiplicator = 1.0
	if self.bonus_buyed.has(augment_data.augment_name):
		price_multiplicator += self.bonus_buyed[augment_data.augment_name]
	self.harvested_mob -= augment_data.beak_cost * price_multiplicator
	print("[PlayerData] Augment buyed")
	match augment_data.type:
		Augment.AugmentType.ReelExtend:
			self.stats["reel_length"] += 0.1
		Augment.AugmentType.SpeedBoost:
			self.stats["speed_mult"] += 0.1
		Augment.AugmentType.Repair:
			self.life = START_LIFE_AMOUNT
		Augment.AugmentType.SteeringImprove:
			self.stats["steering_mult"] += 0.1
	if bonus_buyed.has(augment_data.augment_name):
		bonus_buyed[augment_data.augment_name] += 1
	else:
		bonus_buyed[augment_data.augment_name] = 1
	self.game_augment_buyed.emit(augment_data)

func mob_harvested():
	print("[PlayerData] Harvested mob")
	self.harvested_mob += 1
	self.harvested_mob_total += 1
	
func activate_shop():
	print("[PlayerData] Shop entered")
	self.game_enter_shop.emit()
	is_in_shop = true

func leave_shop():
	print("[PlayerData] Shop leaved")
	is_in_shop = false
	self.game_leave_shop.emit()

func barn_door_destroyed():
	if self.status != GameStatus.LOST:
		print("[PlayerData] You lost")
		self.status = GameStatus.LOST
		self.game_end_lost.emit()

func reset_data():
	self.wave_counter = 0
	self.harvested_mob = 0
	self.harvested_mob_total = 0
	self.stats = {
		"reel_length" : 0.75,
		"speed_mult" : 1.0,
		"steering_mult": 1.0
	}
	self.bonus_buyed = {}
	self.life = START_LIFE_AMOUNT

func restart_game():
	self.reset_data()
	get_tree().reload_current_scene()
	self.start_shopping()

func back_to_main_menu():
	self.reset_data()
	print(get_tree().change_scene_to_file("res://main_menu.tscn"))
