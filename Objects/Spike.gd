extends AnimatableBody2D

var damage_amount = 2

func _on_hurt_box_body_entered(body):
	if body.name == "Player":
		print("Test Spikeyy -- Touchiee --..")
		Events.hurt_spike.emit(damage_amount)
		

