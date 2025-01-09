extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var collision = $CollisionShape2D
@export var box_nro = 0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var in_hurt_area = false
var hurt_signal_sent = false
var in_detection_area = false
var sleeping = false

var sleep_area_signal_sent = false

func _ready():
	animation.play("Sleeping")

func _physics_process(_delta):
	if Global.on_box == true or sleeping:
		animation.play("Sleeping")
		return
		
	if in_hurt_area or in_detection_area:
		animation.play("Hit")
		if in_hurt_area:
			_send_singal()

# ------------HURT AREA--------------
func _on_hurt_area_body_entered(body):
	if body.name == "Player":
		in_hurt_area = true

func _on_hurt_area_body_exited(body):
	if body.name == "Player":
		in_hurt_area = false
		hurt_signal_sent = false

# ------------DETECTION AREA--------------
func _on_front_detection_body_entered(body):
	if body.name == "Player":
		in_detection_area = true

func _on_front_detection_body_exited(body):
	if body.name == "Player":
		in_detection_area = false

# ------------SLEEP AREA--------------
func _on_sleep_body_entered(body):
	if body.name == "Player" and not sleep_area_signal_sent:
		sleeping = true
		Events.player_in_box.emit(false)
		Events.hide_box.emit(box_nro)
		sleep_area_signal_sent = true
		if box_nro != 2:
			Events.audio_stop_play.emit(true)

func _send_singal():
	if not hurt_signal_sent:
		Events.hurt_bear.emit()
		hurt_signal_sent = true
	else:
		pass
