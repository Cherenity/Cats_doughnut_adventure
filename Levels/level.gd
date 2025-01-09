extends Node2D

@onready var start_position = $Player.get_global_position()
@export var level_num = 0
var levelPath

func _ready():
	change_backround_color("1f1f1f")
	Events.change_backround_color.connect(change_backround_color)
	reset_doughnut_array()
	Global.total_points = 0
	Global.gems_collected = 0
	Events.set_player_position.connect(set_player_position)
	Events.player_dead.connect(_player_death_reset)
	Events.change_music.emit("basic")
	Events.cake_doughnuts_transparent.emit()

	#$HUD.level(level_num)
	#print("level " + str(level_num) + " ready : ", Global.gems_collected)
	set_gems_label()
	for gem in $Gems.get_children():
		if Global.level_complete:
			gem.hide()
		else:
			gem.gem_collected.connect(_on_gem_collected)

func _on_gem_collected():
	set_gems_label()

func set_gems_label():
	$HUD.gems(Global.gems_collected)

func change_level():
	get_tree().change_scene_to_file(levelPath)

func _input(event):

	if event.is_action_pressed("toggle_fullscreen"):
			if DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_FULLSCREEN:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			elif DisplayServer.window_get_mode() == DisplayServer.WINDOW_MODE_WINDOWED:
				DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN) 

# used on checkpoints
func set_player_position():
	start_position = $Player.get_global_position()

func _player_death_reset():
	$Player.set_global_position(start_position)

func reset_doughnut_array():
	for i in range(Global.doughuts.size()):
		Global.doughuts[i] = false

func change_backround_color(color_code):
	$ParallaxBackground/ParallaxLayer.modulate = color_code
	
	#705523
	#8d352e
	#d22d76
	#fea9ff
	# 1f1f1f (START color)
	# 0. 705523 (brown)
	# 1. 8bc1ff (blue)
	# 2. ffc19f (pink)
	# 3. ffcd98 (neutral)
	
	#ffcd98 #ilman täytettäv äri
	#sininen donitsi 8bc1ff
	




