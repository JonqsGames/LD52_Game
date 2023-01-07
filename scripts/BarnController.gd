extends Node3D

@onready var animation_player = $AnimationPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	GPlayerData.game_wave_start.connect(self._on_wave_start)
	GPlayerData.game_wave_done.connect(self._on_wave_end)
	GPlayerData.game_leave_shop.connect(self._on_player_leave_shop)
	animation_player.play("OpenDoors")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_wave_end():
	animation_player.play("OpenDoors")

func _on_wave_start():
	animation_player.play_backwards("OpenDoors")

func _on_player_leave_shop():
	animation_player.play("OpenDoors")

func _on_area_3d_body_entered(body):
	animation_player.play_backwards("OpenDoors")
	GPlayerData.activate_shop()

