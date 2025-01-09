extends Area2D
@export var left_direction = true
var sent_signal = false
# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("default")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass


func _on_body_entered(body):
	if body.name == "Player":
		if not sent_signal:
			$AnimatedSprite2D.play("dissapear")
			Events.special_object.emit()
			sent_signal = true
		await get_tree().create_timer(1).timeout
		self.queue_free()
		
