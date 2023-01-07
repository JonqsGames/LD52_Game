extends CenterContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_end_lost.connect(self._on_player_lost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_lost():
	self.visible = true
