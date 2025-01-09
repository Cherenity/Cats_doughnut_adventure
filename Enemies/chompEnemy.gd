extends CharacterBody2D

var SPEED = 30.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

var chomp = false
var moving_left = true

@onready var l_ray = $l_ray
@onready var r_ray = $r_ray

@onready var l_collision = $Sides/l_collision
@onready var r_collision = $Sides/r_collision

@onready var hurt_l = $hurt_area/hurt_l
@onready var hurt_r = $hurt_area/hurt_r

@onready var animation = $AnimatedSprite2D

var player_stop = false

func _physics_process(delta):
	if player_stop == true:
		animation.play("hurt")
		return
	
	if l_ray.is_colliding():
		var l_collider = l_ray.get_collider()
		if l_collider.name != "Player":
			moving_left = false
			animation.flip_h = true
			l_collision.disabled = true
			r_collision.disabled = false
			hurt_r.disabled = false
			hurt_l.disabled = true

	if r_ray.is_colliding():
		var r_collider = r_ray.get_collider()
		if r_collider.name != "Player":
			moving_left = true
			animation.flip_h = false
			l_collision.disabled = false
			r_collision.disabled = true
			hurt_r.disabled = true
			hurt_l.disabled = false
	
	velocity.y += gravity * delta
	velocity.x = -SPEED if moving_left else SPEED
	
	if not chomp:
		animation.play("default")
	else:
		animation.play("chomp")
	
	move_and_slide()
	
func _on_area_2d_body_entered(body):
	if body.name == "Player":
		SPEED = 100.0
		chomp = true
		
func _on_area_2d_body_exited(body):
	if body.name == "Player":
		chomp = false
		SPEED = 30.0

func _on_hurt_area_body_entered(body):
	if body.name == "Player":
		Events.hurt_chomp.emit(moving_left)


func _on_above_body_entered(body):
	if body.name =="Player":
		Events.increase_jump_height.emit()
		player_stop = true


func _on_above_body_exited(body):
	if body.name =="Player":
		Events.decrease_jump_height.emit()
		player_stop = false
