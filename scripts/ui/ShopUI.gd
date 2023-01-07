extends CenterContainer

@onready var beak_counter = $VBoxContainer/RessourceContainer/ResMarker

@onready var card_a = $VBoxContainer/Cards/Card
@onready var card_b = $VBoxContainer/Cards/Card2
@onready var card_c = $VBoxContainer/Cards/Card3
@onready var card_d = $VBoxContainer/Cards/Card4

var res_reel_extand = load("res://data/augments/reel_extand.tres")

# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_enter_shop.connect(self._on_player_enter_shop)
	GPlayerData.game_leave_shop.connect(self._on_player_leave_shop)
	GPlayerData.game_augment_buyed.connect(self._on_player_buy_augment)
	card_a.grab_focus()
	self.generate_shop()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
# CALLBACKS
func _on_player_buy_augment(augment_data : Augment):
	beak_counter.set_ressource_count(GPlayerData.harvested_mob)
	card_a.grab_focus()
	
func _on_player_enter_shop():
	self.visible = true
	# update ressources
	beak_counter.set_ressource_count(GPlayerData.harvested_mob)
	$VBoxContainer/Cards/Card.grab_focus()
func generate_shop():
	# Generated shop
	card_a.set_augment_data(res_reel_extand)
	card_b.set_augment_data(res_reel_extand)
	card_c.set_augment_data(res_reel_extand)
	card_d.set_augment_data(res_reel_extand)

func _on_player_leave_shop():
	self.visible = false
