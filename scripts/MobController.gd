extends CharacterBody3D
class_name MobController

enum MobStatus {
	IDLE,
	WALKING,
	ATTACKING
}

const SPEED = 400.0
const JUMP_VELOCITY = 4.5
const ATTACK_SPAN = 0.5 # seconds
const ATTACK_DMG = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target : Node3D
var status : MobStatus = MobStatus.IDLE

var safe_velocity : Vector3 = Vector3(0,0,0)

var last_attack_timer = 0

@onready var nav_agent = $NavigationAgent3D

func _ready():
	if target != null:
		nav_agent.target_location = self.target.global_position
		self.status = MobStatus.WALKING
	else:
		push_warning("[Mob] Has no target")
	# Connect to global events
	GPlayerData.game_wave_done.connect(self._on_wave_end)

func _process(delta):
	# Attack
	match self.status:
		MobStatus.ATTACKING:
			self.last_attack_timer += delta
			if self.last_attack_timer > ATTACK_SPAN:
				# ATTACK
				self.target.get_parent().attack(ATTACK_DMG)
		MobStatus.WALKING:
			var velocity_to_target = global_position.direction_to(nav_agent.get_next_location()) * SPEED * delta
		#	nav_agent.set_velocity(velocity_to_target)
			safe_velocity = velocity_to_target

func _physics_process(delta):
#	# Get the input direction and handle the movement/deceleration.
#	# As good practice, you should replace UI actions with custom gameplay actions.
#	#var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
#	var direction = global_position.direction_to(nav_agent.get_next_location()) * delta
#	#var direction = (Vector3(input_dir.x, 0, input_dir.y)).normalized() * delta
#	if direction:
#		velocity.x = direction.x * SPEED
#		velocity.z = direction.z * SPEED
#	else:
#		velocity.x = move_toward(velocity.x, 0, delta)
#		velocity.z = move_toward(velocity.z, 0, delta)
	velocity.x = safe_velocity.x
	velocity.z = safe_velocity.z
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	move_and_slide()


func set_target(p_target : Node3D):
	self.target = p_target

func harvest():
	print("[Mob] Has been harvested")
	self.queue_free()

# CALLBACKS
func _on_navigation_agent_3d_velocity_computed(p_safe_velocity):
	safe_velocity = p_safe_velocity

func _on_navigation_agent_3d_target_reached():
	print("[Mob] Reached target")
	self.status = MobStatus.ATTACKING

func _on_wave_end():
	print("[Mob] Mob killed by end of wave")
	self.queue_free()
