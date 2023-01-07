extends HBoxContainer

@onready var counter_label = $Label
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_ressource_count(count):
	self.counter_label.text = "%s" % [count]

func set_to_red():
	self.counter_label.set("theme_override_colors/font_color",Color("#933633"))
func set_to_green():
	self.counter_label.set("theme_override_colors/font_color",Color("#7fa533"))
func set_to_normal():
	self.counter_label.set("theme_override_colors/font_color",Color("#4d3d2f"))
