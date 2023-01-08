extends Node3D

const SPAWN_DELTA = 0.75

@export var target : Node3D
@export var unlock_wave = 0

var last_spawn = -1
var MobPrefab = preload("res://prefabs/mob.tscn")

func _ready():
	pass # Replace with function body.

func _process(delta):
	if GPlayerData.is_wave_running() and GPlayerData.wave_counter >= self.unlock_wave:
		if last_spawn < 0 or last_spawn > SPAWN_DELTA:
			last_spawn = 0.0
			self.produce_mob()
		else:
			last_spawn += delta

func produce_mob():
	var new_mob : MobController = MobPrefab.instantiate()
	new_mob.set_target(self.target)
	self.add_child(new_mob)
	new_mob.transform = Transform3D.IDENTITY
	new_mob.position.x += randf_range(-25.0,25.0)
	new_mob.position.z += randf_range(-0.5,0.5)
