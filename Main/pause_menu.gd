extends Control

func _ready():
	pass

func resume():
	get_tree().paused = false
	$"../../Music".volume_db = +5
	$".".hide()


func pause():
	if Global.exploding_worms.size() < 1:
		get_tree().paused = true
		$"../../Music".volume_db = -5
		$".".show()
		$PanelContainer/VBoxContainer/Resume.grab_focus()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func testEsc():
	if Input.is_action_just_pressed("pause") and get_tree().paused == false:
		pause()
	elif Input.is_action_just_pressed("pause") and get_tree().paused == true:
		resume()


func _on_resume_pressed():
	resume()


func _on_restart_pressed():
	resume()
	get_tree().reload_current_scene()


func _on_quit_pressed():
	get_tree().quit()

func _process(_delta):
	testEsc()


func _on_main_menu_pressed():
	resume()
	get_tree().change_scene_to_file("res://Main/main_menu.tscn")
	


func _on_full_screen_pressed():
	if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
		$PanelContainer/VBoxContainer/FullScreen.text = "Fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
		$PanelContainer/VBoxContainer/FullScreen.text = "Non-fullscreen"
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 


func _on_mute_pressed():
	if $PanelContainer/VBoxContainer/Mute.text == "Mute":
		$PanelContainer/VBoxContainer/Mute.text = "Unmute"
	else:
		$PanelContainer/VBoxContainer/Mute.text = "Mute"
	var music_bus = AudioServer.get_bus_index("Master")
	AudioServer.set_bus_mute(music_bus, not AudioServer.is_bus_mute(music_bus))
