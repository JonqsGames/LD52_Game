extends CenterContainer


@onready var restart_button = $VBoxContainer/HBoxContainer/Restart
@onready var exit_button = $VBoxContainer/HBoxContainer/Exit
@onready var wave_data = $VBoxContainer/WaveData
@onready var kill_data = $VBoxContainer/HarvestData

# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_end_lost.connect(self._on_player_lost)
	restart_button.grab_focus()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_player_lost():
	self.visible = true
	restart_button.grab_focus()
	wave_data.text = "You beat %s wave" % [GPlayerData.wave_counter]
	kill_data.text = "You slaughtered X Zombie Chicken" % [GPlayerData.harvested_mob_total]

func _on_restart_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		print("[Lost UI] Restart game")
		GPlayerData.restart_game()


func _on_exit_gui_input(event):
	if event.is_action_pressed("ui_accept"):
		print("[Lost UI] Exit")
		GPlayerData.back_to_main_menu()
