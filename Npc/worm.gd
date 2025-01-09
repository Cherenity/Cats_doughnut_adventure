extends CharacterBody2D

var speed: float = 20
var moving_left = false
var timer_ready = true

@export var turn_time = 5
@onready var animation = $AnimatedSprite2D
@onready var r_ray = $r_ray
@onready var l_ray = $l_ray
var player_detected_r_ray = false
var player_detected_l_ray = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#EXPLOSION CODE
var player_detected = false
var explosion_area_entered = false
var explosion = false
var hurt = false
var stop_worm = false
var notice_sound_played = false

func _ready():
	animation.play("default")

func _physics_process(_delta: float):
	if stop_worm:
		return
	if r_ray.is_colliding():
		var r_collider = r_ray.get_collider()
		if r_collider.name == "Player":
			if not notice_sound_played:
				$noticeSound.play()
				notice_sound_played = true
			moving_left = false
			player_detected = true
			if not explosion:
				worm_explodes()

	if  l_ray.is_colliding():
		var l_collider = l_ray.get_collider()
		if l_collider.name == "Player":
			if not notice_sound_played:
				$noticeSound.play()
				notice_sound_played = true
			moving_left = true
			player_detected = true
			if not explosion:
				worm_explodes()
	
	if moving_left:
		animation.flip_h = false
		velocity.x = -speed
	else:
		animation.flip_h = true
		velocity.x = speed
	move_and_slide()

	if not player_detected:
		if timer_ready:
			timerMove()

func timerMove():
	timer_ready = false
	if moving_left:
		await get_tree().create_timer(turn_time).timeout
		moving_left = false
	else:
		await get_tree().create_timer(turn_time).timeout
		moving_left = true
	timer_ready = true

func worm_explodes():
	explosion = true
	
	if !Global.exploding_worms.has(self.name):
		# kun mato huomasi pelaajan lisätään listalle
		#pelin voi tauottaa vasta kun poistettu listalta räjähdyksen jälkeen
		Global.exploding_worms.append(self.name)

	speed = speed * 8
	$AnimationPlayer.play("danger")
	await get_tree().create_timer(1).timeout
	$AnimationPlayer.stop()
	animation.self_modulate = Color(1,1,1,1)
	stop_worm = true
	animation.play("explosion")
	$AudioStreamPlayer.play()
	
	if explosion_area_entered and not hurt:
		hurt = true
		Events.worm_hurt.emit()
	
	await get_tree().create_timer(1).timeout
	
	if Global.exploding_worms.has(self.name):
		Global.exploding_worms.erase(self.name)

	queue_free()

func _on_explosion_area_body_entered(body):
	if body.name == "Player":
		explosion_area_entered = true

func _on_explosion_area_body_exited(body):
	if body.name == "Player":
		explosion_area_entered = false

func _on_detection_area_body_exited(body):
	if body.name == "Player":
		player_detected = false
