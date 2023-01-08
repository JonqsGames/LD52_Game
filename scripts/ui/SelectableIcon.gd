extends TextureRect

var focus_texture = load("res://img/icons/box_selected.png")
var unfocus_texture = load("res://img/icons/box.png")


func _on_focus_entered():
	self.texture = focus_texture


func _on_focus_exited():
	self.texture = unfocus_texture
