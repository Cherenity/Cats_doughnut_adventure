extends Area2D

func _on_body_entered(body):
	Events._wall_slide_start.emit()


func _on_body_exited(body):
	Events._wall_slide_end.emit()
