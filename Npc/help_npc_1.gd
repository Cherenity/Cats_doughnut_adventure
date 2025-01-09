extends CharacterBody2D

@onready var animation = $AnimatedSprite2D
@onready var r_ray = $r_ray
@onready var l_ray = $l_ray
var turn_left = false
var turn_right = false
var annoyed = false
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _ready():
	Events.show_exclamation.connect(show_exclamation)


func _physics_process(_delta):
	if not annoyed:
		animation.play("idle")
	else:
		animation.play("annoyed")
	
	if r_ray.is_colliding():
		turn_left = false
		var r_collider = r_ray.get_collider()
		if r_collider.name == "Player":
			if turn_right != true:
				animation.flip_h = true
				turn_right = true
				
	elif  l_ray.is_colliding():
		turn_right = false
		var l_collider = l_ray.get_collider()
		if l_collider.name == "Player":
			if turn_left != true:
				animation.flip_h = false
				turn_left = true

func _on_area_2d_body_entered(body):
	var final_doughnut_found = Global.doughuts[4]
	var almost_final_doughnut_found = Global.doughuts[3]
	var first_doughnut = Global.doughuts[0]
	if body.name == "Player":
		if final_doughnut_found:
			$Exclamation.show() 
			$Board/NpcBoard.text = "Thank you! You saved my birthday doughnut cake!"
		elif  almost_final_doughnut_found:
			$Exclamation.show()
			$Board/NpcBoard.text = "Only one left! I think the portal at the beginning is now open."
		elif first_doughnut:
			$Exclamation.show()
			$Board/NpcBoard.text = "One found already! You're doing great!"
		else:
			$Board/NpcBoard.text = "Could you find my birthday cake doughnuts, please?"
			
		$Exclamation.hide()
		$Board.show()


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$Board.hide()


func _on_area_body_entered(body):
	if body.name == "Player":
		annoyed = true


func _on_area_body_exited(body):
	if body.name == "Player":
		annoyed = false

func show_exclamation():
	$Exclamation.show()
