extends CharacterBody3D


const SPEED = 200.0
const ROTATION_SPEED = 3.0
const JUMP_VELOCITY = 4.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle Jump.
#	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
#		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("ui_right", "ui_left", "ui_up", "ui_down")
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
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)

	move_and_slide()


func _on_reel_area_body_entered(body):
	body.harvest()
	GPlayerData.mob_harvested()
