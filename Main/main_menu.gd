extends Node2D

var hidden_credits = true

func _ready():
	print("Main Menu is Ready")
	$Options/StartButton.grab_focus()

	if !OS.has_feature("pc"):
		$Options/FullscreenButton.hide()
		$Options/QuitButton.hide()

func _input(event):
	if event.is_action_pressed("toggle_fullscreen"):
		if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
		elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 

func _on_start_button_pressed():
	get_tree().change_scene_to_file("res://Levels/level_1.tscn")

func _on_fullscreen_button_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 


func _on_quit_button_pressed():
	get_tree().quit()


func _on_credits_pressed():
	if hidden_credits:
		hidden_credits = false
	else:
		hidden_credits = true
	
	if hidden_credits:
		$Credits1.hide()
		$Credits3.hide()
		$Credits4.hide()
		$Credits5.hide()
	else:
		$Credits1.show()
		$Credits3.show()
		$Credits4.show()
		$Credits5.show()


