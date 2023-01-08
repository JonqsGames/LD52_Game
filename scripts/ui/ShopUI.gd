extends CenterContainer

@onready var beak_counter = $VBoxContainer/RessourceContainer/ResMarker

@onready var card_list = [
	get_node("VBoxContainer/Cards/Card"),
	get_node("VBoxContainer/Cards/Card2"),
	get_node("VBoxContainer/Cards/Card3"),
	get_node("VBoxContainer/Cards/Card4")
]

var res_list = [
	load("res://data/augments/reel_extand.tres"),
	load("res://data/augments/repair.tres"),
	load("res://data/augments/speed_boost.tres"),
	load("res://data/augments/steering.tres")
]
var res_reel_extand = load("res://data/augments/reel_extand.tres")
var random_gen = RandomNumberGenerator.new()
# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_enter_shop.connect(self._on_player_enter_shop)
	GPlayerData.game_leave_shop.connect(self._on_player_leave_shop)
	GPlayerData.game_augment_buyed.connect(self._on_player_buy_augment)
	card_list[0].grab_focus()
	self.generate_shop()
	random_gen.randomize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
# CALLBACKS
func _on_player_buy_augment(augment_data : Augment):
	beak_counter.set_ressource_count(GPlayerData.harvested_mob)
	self.generate_shop()
	card_list[0].grab_focus()
	
func _on_player_enter_shop():
	self.visible = true
	# update ressources
	beak_counter.set_ressource_count(GPlayerData.harvested_mob)
	card_list[0].grab_focus()

func generate_shop():
	# Generated shop
	for card in card_list:
		card.set_augment_data(res_list[random_gen.randi_range(0,res_list.size()-1)])

func _on_player_leave_shop():
	self.visible = false


func _on_refresh_gui_input(event):
	if event.is_action_pressed("ui_accept"):
			self.generate_shop()
			card_list[0].grab_focus()


func _on_exit_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		GPlayerData.leave_shop()
