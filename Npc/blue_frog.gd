extends CharacterBody2D

@export var jump_max = 0 

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var animation = $AnimatedSprite2D

@onready var b_collision = $base_collision
@onready var r_collision = $RighArea/r_collision

var slurping = false
var has_emited_signal = false
var returning = false

func _ready():
	Events.show_the_frog.connect(reset_frog)

func _physics_process(_delta):
	if not slurping or returning == true:
		animation.play("default")


func _on_righ_area_body_entered(body):
	if body.name == "Player":
		if not has_emited_signal:
			has_emited_signal = true
			r_collision.set_deferred("disabled", true)
			Events.add_jump_max.emit(jump_max)

		animation.flip_h = false
		slurping = true
		
		animation.play("slurp_explosion")
		await get_tree().create_timer(0.4).timeout
		$slurpSound.play()
		await get_tree().create_timer(1.8).timeout

		self.hide()
		b_collision.set_deferred("disabled", true)

func reset_frog():
	slurping = false
	has_emited_signal = false
	self.show()
	b_collision.set_deferred("disabled", false)
	r_collision.set_deferred("disabled", false)
	
