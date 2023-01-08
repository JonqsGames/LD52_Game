extends Node3D

const ROT_SPEED = 0.5

var turning_speed = 0.0
var reel_size = 0.0

@export var collider_main : CollisionShape3D
@export var collider_area : CollisionShape3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if reel_size != GPlayerData.stats["reel_length"]:
		reel_size = GPlayerData.stats["reel_length"]
		self.scale.x = reel_size
		collider_main.shape.height = 4.0 * reel_size
		collider_area.shape.height = 4.0 * reel_size
		collider_main.shape.radius = 0.4 * reel_size
		collider_area.shape.radius = 0.4 * reel_size + 0.1

	self.rotate_x(ROT_SPEED * delta * turning_speed)
