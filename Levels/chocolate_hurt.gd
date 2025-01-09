extends AnimatableBody2D

var sinking_start = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if sinking_start:
		$AnimationPlayer.play("test")
		sinking_start = false


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		sinking_start = true
		Events.player_sink.emit(true)
		$AudioStreamPlayer2D.play()

func _on_area_2d_body_exited(body):
		if body.name == "Player":
			$AnimationPlayer.stop()
			Events.player_sink.emit(false)
			$AudioStreamPlayer2D.stop()
			#$SinkCollision.scale.y = 1

func _on_kill_area_body_entered(body):
	if body.name == "Player" and not Global.level_complete:
		Events.hurt_spike.emit(9)
	elif body.name == "Player":
		Events.teleport_player.emit(-815.23, 579.461)
