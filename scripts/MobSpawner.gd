extends Node3D

const SPAWN_DELTA = 3.0

@export var target : Node3D

var last_spawn = -1
var MobPrefab = preload("res://prefabs/mob.tscn")


func _ready():
	pass # Replace with function body.

func _process(delta):
	if GPlayerData.is_wave_running():
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
