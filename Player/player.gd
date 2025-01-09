extends CharacterBody2D
class_name player

# Declare a Timer node
var rotationTimer: Timer

@export var ghost_node : PackedScene
@onready var player_sprite = $Pivot/AnimatedSprite2D
@onready var particles = $GPUParticles2D
@onready var ghost_timer = $GhostTimer


@export var maxHealth = 9
@onready var currentHealth: int = maxHealth

@export var charge_rate = 22.0
@export var stamina_use = 25.0
@export var max_stamina = 200.0
@onready var stamina: float = max_stamina

@export var knockbackPower: int = 500

const SPEED = 140.0
var ADD_SPEED
const DASH_SPEED = 400.0
var dashing = false
var special_dash = false
var state = "normal"

const JUMP_VELOCITY = -290.0
var extra_jump_velocity = 0
#const WALL_SLIDE_ACCELERATION = 10
#const MAX_WALL_SLIDE_SPEED = 120

var jump_max = 2
var jump_count = 0
var life_count = 5

var isgrounded = true
#var can_wall_slide = false

var game_paused = false
var player_alive = true

var in_box = false
var player_sinking = false
var player_teleporting = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	_set_max_health()
	_set_max_stamina()
	Events.hurt_spike.connect(_hurt_spike)
	Events.hurt_chomp.connect(hurtChomp)
	Events.start_healing.connect(start_healing)
	Events.cloud_jump.connect(cloud_jump)
	#Events._wall_slide_start.connect(start_wall_slide)
	#Events._wall_slide_end.connect(end_wall_slide)
	Events.add_jump_max.connect(increase_jump_max)
	Events.hurt_bear.connect(hurtbear)
	Events.increase_jump_height.connect(increase_jump_height)
	Events.decrease_jump_height.connect(decrease_jump_height)
	Events.reset_current_health.connect(reset_current_health)
	Events.player_in_box.connect(set_can_box)
	Events.player_sink.connect(player_sink)
	Events.show_info_text.connect(show_speechBubble)
	Events.teleport_player.connect(set_player_position)
	Events.worm_hurt.connect(worm_hurts)
	Events.special_object.connect(special_object)
	Events.death_reset.connect(player_death)

func _physics_process(delta):
	if player_alive == false or player_teleporting == true:
		return
	
	
	if special_dash and is_on_floor():
		player_sprite.play("run")
		if $Pivot/AnimatedSprite2D.flip_h == true:
			velocity.x = -1000
			move_and_slide()
		else:
			$Pivot/AnimatedSprite2D.flip_h = true
			velocity.x = -1000
			move_and_slide()
		return

	if isgrounded == false and is_on_floor() == true and not $AnimationPlayer.is_playing():
		$AnimationPlayer.play("land")
	
	isgrounded = is_on_floor()
	
	var a = get_node_or_null("../ExampleBalloon")	
	if not a == null:
		return
	
	_set_current_health()
	
	# Add the gravity.
	if not is_on_floor():
		Global.player_jumping = true
		velocity.y += gravity * delta
	
	if is_on_floor():
		Global.player_jumping = false
	
	# resetting jump_count
	if is_on_floor() and jump_count!=0:
		jump_count = 0

	# Creating double jump & JUMP NEW
	if jump_count < jump_max:
		if Input.is_action_just_pressed("jump"):
			if extra_jump_velocity != 0:
				velocity.y = JUMP_VELOCITY * extra_jump_velocity
			else:
				if not player_sinking:
					velocity.y = JUMP_VELOCITY
				else:
					velocity.y = JUMP_VELOCITY + 160
					#130
			
			# soundeffect?
			#$JumpSfx.play()
			jump_count += 1
	
	#if can_wall_slide == true:
		#if is_on_wall() && Input.is_action_pressed("move_left"):
			#velocity.y = -200
			#if is_on_wall() && Input.is_action_pressed("move_right"):
				#velocity.y = 0
#
		#if is_on_wall() && Input.is_action_pressed("move_right"):
			#velocity.y = -200
			#if is_on_wall() && Input.is_action_pressed("move_left"):
				#velocity.y = 0
			#
	Events.emit_signal("stamina_changed", stamina)
	stamina += delta * charge_rate
	stamina = min(stamina, max_stamina)
	
	if Input.is_action_just_pressed("dash") and stamina >= stamina_use:
		if (Input.get_axis("move_left","move_right"))==0.0:
			return
		stamina -= 25
		dashing = true
		ghost_timer.start()
		$dash_timer.start()


	var direction = Input.get_axis("move_left", "move_right")
	if state == "normal":
		if direction:
			if dashing:
				particles.emitting = true
				velocity.x = DASH_SPEED * direction
			else:
				particles.emitting = false
				#PITÄÄ MIETTIÄ!!
				velocity.x = direction * SPEED * 60 * delta
				if not in_box:
					player_sprite.play("run")
				else:
					player_sprite.play("box_run")
				
			if direction == -1:
				player_sprite.flip_h = true
			else:
				player_sprite.flip_h = false
				
		else:
			particles.emitting = false
			if not in_box:
				player_sprite.play("idle")
			else:
				player_sprite.play("box_idle")
			
			velocity.x = move_toward(velocity.x, 0, SPEED / 2)
	else:
		hurt_timer()

	if not is_on_floor():
		particles.emitting = true
		if not in_box:
			player_sprite.play("jump")
		else:
			player_sprite.play("box_jump")
			
	
	move_and_slide()

func _on_dash_timer_timeout():
	dashing = false
	ghost_timer.stop()

func add_ghost():
	var ghost = ghost_node.instantiate()
	ghost.set_property(position)
	ghost.set_flip($Pivot/AnimatedSprite2D.flip_h)
	get_tree().current_scene.add_child(ghost)

func _on_ghost_timer_timeout():
	add_ghost()

#set_current_health
func _set_current_health():
	Events.set_current_health.emit(currentHealth)

func start_healing():
	if currentHealth == maxHealth:
		Events.show_info_text.emit("No Effect", true)
		await get_tree().create_timer(3).timeout
		Events.show_info_text.emit("", false)
	else:
		while currentHealth < maxHealth:
			await get_tree().create_timer(0.2).timeout
			currentHealth += 1

func _set_max_health():
	Events.set_max_health.emit(maxHealth)

func _set_max_stamina():
	Events.set_max_stamina.emit(max_stamina)

func _hurt_spike(amount):
	currentHealth -= amount
	if currentHealth <= 0:
		player_death()
		return
	knockback()

#.normalized()
func knockback():
	velocity.y = -knockbackPower
	$AnimationPlayer.play("knockback")

func hurtChomp(moving_left):
	$AnimationPlayer.play("knockback")
	state = "hurt"

	if moving_left == true:
		currentHealth -= 3
		if currentHealth <= 0:
			player_death()
		else:
			velocity.y = -300
			velocity.x = -200
	else:
		currentHealth -= 3
		if currentHealth <= 0:
			player_death()
		else:
			velocity.y = -300
			velocity.x = 200

func hurt_timer():
	await get_tree().create_timer(0.2).timeout
	state = "normal"

func cloud_jump():
	velocity.y = -knockbackPower

#func start_wall_slide():
	#can_wall_slide = true
#
#func end_wall_slide():
	#can_wall_slide = false

func increase_jump_max(nro):

	jump_max = nro
	await get_tree().create_timer(1).timeout
	$frogProgress.show()

	reset_jump_max()
	
func reset_jump_max():
	$AnimationPlayer.play("jump_buff_color")
	$frogProgress.value = 10
	await get_tree().create_timer(2.5).timeout
	$frogProgress.value = 8
	await get_tree().create_timer(2.5).timeout
	$frogProgress.value = 6
	await get_tree().create_timer(2.5).timeout
	$frogProgress.value = 4
	await get_tree().create_timer(2.5).timeout
	$frogProgress.value = 2
	await get_tree().create_timer(2.5).timeout
	$frogProgress.value = 0
	await get_tree().create_timer(0.5).timeout
	$frogProgress.hide()
	$AnimationPlayer.stop()
	jump_max = 2
	await get_tree().create_timer(0.5).timeout 
	self.modulate = Color(1,1,1,1)
	
	Events.show_the_frog.emit()

func hurtbear():
	currentHealth -= 3
	if currentHealth == 0:
		player_death()
		return
	$AnimationPlayer.play("knockback")
	state = "hurt"
	velocity.y = -200
	velocity.x = -500

func increase_jump_height():
	extra_jump_velocity = 1.3

func decrease_jump_height():
	extra_jump_velocity = 0

func reset_current_health():
	currentHealth = maxHealth

func player_death():
	if player_alive:
		player_alive = false
		in_box = false
		Events.set_current_health.emit(0)
		if player_alive == false:
			Events.audio_stop_play.emit(false)
			$playerDeath.play()
			$AnimationPlayer.play("player_death")
			$Board.show()		
			$Board/text.text = "Lives 0... Reawakening..."
		await get_tree().create_timer(4).timeout
		Events.audio_stop_play.emit(true)
		currentHealth = maxHealth
		stamina = max_stamina
		$Board.hide()		
		$Board/text.text = ""
		player_alive = true
		self.scale.x = 1
		self.scale.y = 1
		self.z_index = 1
		self.modulate = Color(1,1,1,1)
		Events.player_dead.emit()

func set_can_box(box):
	if box:
		in_box = true
		Global.on_box = true
		$AnimationPlayer.play("in_box_color")
		Events.audio_stop_play.emit(false)
		$AudioStreamPlayer2D.play()
	else:
		$AudioStreamPlayer2D.stop()
		#Tämä lisätty karhulle tässä tapauksessa
		# Boxille jos tulee näkyviin (pelaaja  ei onnistunut)
		#Events.audio_stop_play.emit(true)
		in_box = false
		Global.on_box = false
		$AnimationPlayer.stop()

func player_sink(sinking):
	if sinking:
		player_sinking = true
	else:
		player_sinking = false

func show_speechBubble(text, active):
	if active:
		$Board.show()
		$Board/text.text = text
	else:
		$Board/text.text = ""
		$Board.hide()

func set_player_position(x,y):
	player_teleporting = true
	$TeleportSound.play()
	await get_tree().create_timer(0.8).timeout
	self.hide()
	await get_tree().create_timer(0.8).timeout
	self.show()
	player_teleporting = false
	position.x = x
	position.y = y

func worm_hurts():
	$AnimationPlayer.play("chomphurt")
	velocity.y = -400
	currentHealth -= 4
	if currentHealth <= 0:
		player_death()
		return

func special_object():
	special_dash = true
	particles.emitting = true

	await get_tree().create_timer(0.7).timeout
	special_dash = false
	particles.emitting = false
