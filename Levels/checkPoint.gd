extends AnimatableBody2D
@onready var checkText = $text


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_enter_area_body_entered(body):
	if body.name == "Player":
		$AnimatedSprite2D.play("enter")
		checkText.show()
		Events.set_player_position.emit()


func _on_enter_area_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite2D.play("default")
		checkText.hide()
