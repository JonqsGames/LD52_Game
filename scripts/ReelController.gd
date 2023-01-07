extends MeshInstance3D

const ROT_SPEED = 4.0

var turning_speed = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	self.rotate_x(ROT_SPEED * delta * turning_speed)
	print("[Reel] Turning")
