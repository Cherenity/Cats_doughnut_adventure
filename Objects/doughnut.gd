extends AnimatableBody2D

@export var nro = 0
@export var slice = true
@export var text = "Yay!"
var found = false
var victory = false
var victory_sound = "res://Music/victory_sound.mp3"

# Called when the node enters the scene tree for the first time.
func _ready():
	Events.cake_doughnuts_transparent.connect(set_cake_soughnuts_transparent)
	Events.victoryDoughnuts.connect(victory_particles)
	$AnimatedSprite2D.frame = nro


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not found:
		if nro < 5 and Global.doughuts[nro]:
			found = true
			$AnimatedSprite2D.self_modulate = "ffffff"

func _on_area_2d_body_entered(body):
	if body.name == "Player" and nro > 6 and found == false:
		found = true
		if (nro-7) == 4:
			Events.victoryDoughnuts.emit()
			Events.show_exclamation.emit()
			Events.show_cake_gems.emit()
			Events.change_backround_color.emit("ffffff")
			victory = true
			Global.level_complete = true
			Events.teleport_player.emit(-861, 590)

		elif (nro-7)==3:
			Events.show_exclamation.emit()
			Events.hide_all_info_boards.emit()
			Events.change_backround_color.emit("ffffc9")
		elif (nro-7)==0:
			Events.show_exclamation.emit()
			Events.change_backround_color.emit("705523")
		elif (nro-7)==1:
			Events.change_backround_color.emit("ffc19f")
		elif (nro-7)==2:
			Events.change_backround_color.emit("8bc1ff")
		
		Events.found_doughnut_hud.emit(nro-7)
		Global.doughuts[nro-7] = true
		if not victory:
			$AudioStreamPlayer2D.play()
		else:
			var audio = load(victory_sound)
			$AudioStreamPlayer2D.stream = audio
			$AudioStreamPlayer2D.play()
			Events.change_music.emit("happy_bday")
			Events.hide_all_info_boards.emit()
			
		Events.show_info_text.emit(text, true)
		$text.show()
		$GPUParticles2D.show()
		await get_tree().create_timer(0.75).timeout
		$AnimationPlayer.play("Doughnut_move")
		Global.total_points += 500
		await get_tree().create_timer(0.75).timeout
		Events.doughnut_points.emit()
		Events.show_info_text.emit("", false)
		$text.hide()
		$GPUParticles2D.hide()
		await get_tree().create_timer(0.75).timeout
		self.hide()
		
		queue_free()

func victory_particles():
	if self.nro < 5:
		$GPUParticles2D.show()

func set_cake_soughnuts_transparent():
	if slice:
		if nro < 5 and not Global.doughuts[nro]:
			$AnimatedSprite2D.self_modulate = "ffffff4c"
