extends CharacterBody3D
class_name MobController

enum MobStatus {
	IDLE,
	WALKING,
	ATTACKING
}

const SPEED = 200.0
const SPEED_PER_WAVE = 50.0
const JUMP_VELOCITY = 4.5
const ATTACK_SPAN = 0.1 # seconds
const ATTACK_DMG = 1

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")
var target : Node3D
var status : MobStatus = MobStatus.IDLE

var safe_velocity : Vector3 = Vector3(0,0,0)

var last_attack_timer = 0
var next_scream_timer = 0

var is_dead = false

var audio_list = [
	load("res://audio/chicken1.wav"),
	load("res://audio/chicken2.wav")
]

@onready var nav_agent = $NavigationAgent3D
@onready var animation_player = $AnimationPlayer
@onready var shred_particles = $ShredFeather
@onready var scream_audio = $ScreamAudioA

func _ready():
	if target != null:
		nav_agent.target_location = self.target.global_position
		self.status = MobStatus.WALKING
	else:
		push_warning("[Mob] Has no target")
	# Connect to global events
	GPlayerData.game_wave_done.connect(self._on_wave_end)
	GPlayerData.game_end_lost.connect(self._on_wave_end)
	next_scream_timer = randf_range(1.0,8.0)

func _process(delta):
	# Attack
	match self.status:
		MobStatus.ATTACKING:
			self.last_attack_timer += delta
			if self.last_attack_timer > ATTACK_SPAN:
				self.last_attack_timer = 0
				# ATTACK
				self.target.get_parent().attack(ATTACK_DMG)
		MobStatus.WALKING:
			var calc_speed = SPEED + SPEED_PER_WAVE * GPlayerData.wave_counter
			var velocity_to_target = global_position.direction_to(nav_agent.get_next_location()) * calc_speed * delta
			safe_velocity = velocity_to_target
			next_scream_timer -= delta
	if next_scream_timer <= 0:
#		print("[Mob] Scream")
		next_scream_timer = randf_range(3.5,12.0)
		var sound_index = randi_range(0,self.audio_list.size()-1)
		self.scream_audio.stream = audio_list[sound_index]
		self.scream_audio.play()
		

func _physics_process(delta):
	if self.status == MobStatus.WALKING:
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
		var look_at_dir = nav_agent.get_next_location()
		look_at_dir.y = self.global_position.y
		self.look_at(look_at_dir)
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
	self.is_dead = true
	self.set_collision_layer_value(1, false)
	self.set_collision_layer_value(2, false)
	animation_player.play("Shred")
	shred_particles.restart()
	self.status = MobStatus.IDLE
	var tween = create_tween()
	tween.tween_property(self.scream_audio, "pitch_scale", 2.0, 2.5)
	self.scream_audio.stream = audio_list[1]
	self.scream_audio.play()
#	self.queue_free()

# CALLBACKS
func _on_navigation_agent_3d_velocity_computed(p_safe_velocity):
	safe_velocity = p_safe_velocity

func _on_navigation_agent_3d_target_reached():
	print("[Mob] Reached target")
	self.status = MobStatus.ATTACKING

func _on_wave_end():
	print("[Mob] Mob killed by end of wave")
	self.queue_free()


func _on_animation_player_animation_finished(anim_name):
	if anim_name == "Shred":
		self.queue_free()
