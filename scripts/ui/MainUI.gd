extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_leave_shop.connect(self._on_player_leave_shop)
	GPlayerData.game_enter_shop.connect(self._on_player_enter_shop)
	GPlayerData.game_end_lost.connect(self._on_player_lost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func _on_player_enter_shop():
#	self.visible = false
	pass

func _on_player_leave_shop():
#	self.visible = true
	pass

func _on_player_lost():
#	self.visible = false
	pass
