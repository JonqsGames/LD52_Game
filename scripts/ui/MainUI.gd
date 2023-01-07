extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_leave_shop.connect(self._on_player_leave_shop)
	GPlayerData.game_enter_shop.connect(self._on_player_enter_shop)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_enter_shop():
	self.visible = false

func _on_player_leave_shop():
	self.visible = true
