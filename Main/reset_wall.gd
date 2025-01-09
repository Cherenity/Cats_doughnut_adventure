extends Area2D


func _on_reset_wall_body_entered(body):
	if body.name == "Player":
		if !Global.level_complete:
			Events.death_reset.emit()
		else:
			Events.teleport_player.emit(-815.23, 579.461)
	#get_tree().reload_current_scene.call_deferred()
