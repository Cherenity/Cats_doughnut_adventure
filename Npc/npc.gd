extends CharacterBody2D

var healed = false

func _ready():
	$AnimatedSprite2D.play("default")
	
func _physics_process(_delta):
	pass


func _on_area_2d_body_entered(body):
	if not healed:
		if body.name == "Player":
			$Board.show()
			$AnimatedSprite2D.play("healing")
			Events.start_healing.emit()
			healed = true


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		await get_tree().create_timer(2).timeout
		$Board.hide()
		$AnimatedSprite2D.play("death")
		await get_tree().create_timer(2.5).timeout
		queue_free()
		
		
