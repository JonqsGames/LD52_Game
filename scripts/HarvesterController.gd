extends CharacterBody3D

const SPEED = 400.0
const DECEL_SPEED = 100.0
const ROTATION_SPEED = 3.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.001
const CAMERA_MAX_X_ROT = 1.0
const CAMERA_TWEEN_DURATION = 0.6

@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
var camera_vert_angle = 0
@export var shop_camera_holder : Node3D
@export var security_camera_texture : ViewportTexture
var is_camera_moving = false

@onready var reel_controller = $Reel
@onready var wheel = $WheelHolder/Wheel

# CAR CONTROLS
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
@export var wheel_base = 2.0 # distance between wheels
@export var steerring_max = 12.0 # Max rot of wheels
@export var power = 6.0
@export var brake = -9.0
@export var friction = -2.0
@export var drag = -2.0
@export var reverse_power = 3.0

var accel = Vector3.ZERO
var steer_angle = 0.0

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Attach to global events
	GPlayerData.game_enter_shop.connect(self._on_entering_shop)
	GPlayerData.game_leave_shop.connect(self._on_leaving_shop)
	var mat = $SecurityScreen.get_surface_override_material(0) 
	mat.albedo_texture = security_camera_texture
	$SecurityScreen.set_surface_override_material(0,mat)

func _input(event):
	if !GPlayerData.is_locked():
		if event is InputEventMouseMotion:
			var mouse_motion = -event.relative
			# camera control
			self.camera_pivot.rotate_y(mouse_motion.x * MOUSE_SENSITIVITY)
			self.camera.rotate_x(mouse_motion.y * MOUSE_SENSITIVITY)
			self.camera.rotation.x = clamp(self.camera.rotation.x, -CAMERA_MAX_X_ROT, CAMERA_MAX_X_ROT)

func _physics_process(delta):
	if GPlayerData.is_locked():
		pass
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta
		else:
			var input_dir = Input.get_vector("turn_right", "turn_left", "move_forward", "move_backward")
			#
			steer_angle = input_dir.x * deg_to_rad(steerring_max)
			accel = Vector3.ZERO
			if input_dir.y < 0:
				accel = -transform.basis.z * power * GPlayerData.stats["speed_mult"]
			elif input_dir.y > 0:
				accel = -transform.basis.z * brake
			apply_friction(delta)
			calculate_steering(delta)
			velocity += accel * delta
		move_and_slide()
		self.wheel.rotate_y(steer_angle)
		GPlayerData.harvester_speed = (global_transform.affine_inverse().basis * velocity).z
		reel_controller.turning_speed = GPlayerData.harvester_speed


# CAR UTILS
func apply_friction(delta):
	if velocity.length() < 0.2 and accel.length() == 0:
		#full stop
		velocity.x = 0.0
		velocity.y = 0.0
	var friction_force = velocity * friction * delta
	var drag_force = velocity * velocity.length() * drag * delta
	accel += drag_force + friction_force

func calculate_steering(delta):
	var rear_wheel = transform.origin + transform.basis.z * wheel_base / 2.0
	var front_wheel = transform.origin - transform.basis.z * wheel_base / 2.0
	rear_wheel += velocity * delta
	front_wheel += velocity.rotated(transform.basis.y, steer_angle) * delta
	var new_heading = rear_wheel.direction_to(front_wheel)
	var d = new_heading.dot(velocity.normalized())
	if d > 0:
		velocity = new_heading * velocity.length()
	if d < 0:
		velocity = - new_heading * min(velocity.length(), reverse_power)
	look_at(transform.origin + new_heading, transform.basis.y)

# CALLBACKS
func _on_reel_area_body_entered(body):
	body.harvest()
	GPlayerData.mob_harvested()

func _on_tween_camera_done():
	self.is_camera_moving = false
	print("[Harvester] Camera Tweening done")
	if GPlayerData.is_in_shop:
		self.global_rotate(Vector3(0,1,0),PI)
	
func _on_leaving_shop():
	self.camera.top_level = false
	# TODO Reset position
	is_camera_moving = true
	var tween = create_tween()
	tween.tween_property(camera, "position", Vector3(0,0,0), CAMERA_TWEEN_DURATION)
	tween.parallel().tween_property(camera, "global_rotation", Vector3(0,PI,0), CAMERA_TWEEN_DURATION)
	tween.tween_callback(self._on_tween_camera_done)
	
func _on_entering_shop():
	self.camera.top_level = true
	is_camera_moving = true
	var tween = create_tween()
	tween.tween_property(camera, "global_position", self.shop_camera_holder.global_position, CAMERA_TWEEN_DURATION)
	tween.parallel().tween_property(camera, "global_rotation", self.shop_camera_holder.global_rotation, CAMERA_TWEEN_DURATION)
	tween.tween_callback(self._on_tween_camera_done)
