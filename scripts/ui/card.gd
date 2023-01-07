extends TextureRect

@export var augment_data : Augment

var focus_texture = load("res://img/AugmentCardSelected.png")
var unfocus_texture = load("res://img/AugmentCard.png")

@onready var res_data = $VBoxContainer/Ressources/HBoxContainer/ResMarker
@onready var card_title = $VBoxContainer/CenterContainer/CardTitle
@onready var card_texture = $VBoxContainer/CenterContainer2/TextureRect
@onready var card_desc = $VBoxContainer/CenterContainer3/RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_augment_data(data : Augment):
	self.augment_data = data
	res_data.set_ressource_count(data.beak_cost)
	card_title.text = data.augment_name
	card_texture.texture = data.image
	card_desc.text = data.description

func _on_focus_entered():
	self.texture = focus_texture
	if augment_data.beak_cost > GPlayerData.harvested_mob:
		res_data.set_to_red()
	else:
		res_data.set_to_green()

func _on_focus_exited():
	self.texture = unfocus_texture
	res_data.set_to_normal()


func _on_gui_input(event : InputEvent):
	if event.is_action_pressed("ui_accept"):
		if augment_data.beak_cost > GPlayerData.harvested_mob:
			print("[Card] Cannot buy")
		else:
			GPlayerData.buy_augment(augment_data)
#		print("[Card] %s received an input %s" % [self.name, event])
