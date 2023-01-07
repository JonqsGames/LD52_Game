extends CharacterBody3D

const SPEED = 400.0
const DECEL_SPEED = 200.0
const ROTATION_SPEED = 3.0
const JUMP_VELOCITY = 4.5
const MOUSE_SENSITIVITY = 0.001
const CAMERA_MAX_X_ROT = 1.0
const CAMERA_TWEEN_DURATION = 0.6

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

@onready var camera = $CameraPivot/Camera3D
@onready var camera_pivot = $CameraPivot
var camera_vert_angle = 0
@export var shop_camera_holder : Node3D
var is_camera_moving = false

@onready var reel_controller = $Reel

func _ready(): 
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	# Attach to global events
	GPlayerData.game_enter_shop.connect(self._on_entering_shop)
	GPlayerData.game_leave_shop.connect(self._on_leaving_shop)

func _input(event):
	if !GPlayerData.is_in_shop:
		if event is InputEventMouseMotion:
			var mouse_motion = -event.relative
			# camera control
			self.camera_pivot.rotate_y(mouse_motion.x * MOUSE_SENSITIVITY)
			self.camera.rotate_x(mouse_motion.y * MOUSE_SENSITIVITY)
			self.camera.rotation.x = clamp(self.camera.rotation.x, -CAMERA_MAX_X_ROT, CAMERA_MAX_X_ROT)

func _physics_process(delta):
	if GPlayerData.is_in_shop:
		# Move camera to
		pass
	else:
		# Add the gravity.
		if not is_on_floor():
			velocity.y -= gravity * delta

		# Handle Jump.
	#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#		velocity.y = JUMP_VELOCITY

		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("turn_right", "turn_left", "move_forward", "move_backward")
		# Rotate
		var rotation_value = input_dir.x * ROTATION_SPEED * delta
		if self.test_move(transform, Vector3(0,0,0)):
			print("[Harvester] Stuck %s" % [self.get_wall_normal()])
			
		if rotation_value != 0.0:
			var rotated_transform = self.transform.rotated(Vector3(0.0,1.0,0.0),rotation_value)
			if self.test_move(rotated_transform, Vector3(0,0,0), null, 0.1):
				print("[Harvester] Collide on rotate")
			else:
				self.rotate_y(rotation_value)
		
		# Move
		var direction = (transform.basis * Vector3(0, 0, input_dir.y)).normalized() * delta
		if direction:
			velocity.x = direction.x * SPEED
			velocity.z = direction.z * SPEED
		else:
			velocity.x = move_toward(velocity.x, 0, delta * DECEL_SPEED)
			velocity.z = move_toward(velocity.z, 0, delta * DECEL_SPEED)

		move_and_slide()
		reel_controller.turning_speed = input_dir.y
	

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
	tween.tween_property(camera, "global_position", self.camera_pivot.global_position, CAMERA_TWEEN_DURATION)
	tween.parallel().tween_property(camera, "global_rotation",self.camera_pivot.global_rotation, CAMERA_TWEEN_DURATION)
	tween.tween_callback(self._on_tween_camera_done)
	
func _on_entering_shop():
	self.camera.top_level = true
	is_camera_moving = true
	var tween = create_tween()
	tween.tween_property(camera, "global_position", self.shop_camera_holder.global_position, CAMERA_TWEEN_DURATION)
	tween.parallel().tween_property(camera, "global_rotation", self.shop_camera_holder.global_rotation, CAMERA_TWEEN_DURATION)
	tween.tween_callback(self._on_tween_camera_done)
