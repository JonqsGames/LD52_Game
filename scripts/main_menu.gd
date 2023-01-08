extends Control

const SAFETY_TIMER = 2.0

var timer = 0

func _process(delta):
	timer += delta
	if timer > SAFETY_TIMER and Input.is_action_just_pressed("ui_accept"):
		print("Starting game")
		get_tree().change_scene_to_file("res://main_scene.tscn")
