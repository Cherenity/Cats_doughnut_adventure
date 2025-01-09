extends Node

# SETTING / UPDATING PLAYER HEALTH
signal set_current_health(current_health: int)
signal set_max_health(max_health: int)
signal reset_current_health(current_health: int)

# HURT OBJECTS
signal hurt_spike(hurt_amount: int)
signal hurt_chomp()
signal hurt_bear()

signal increase_jump_height()
signal decrease_jump_height()

# STAMINA
signal stamina_changed(value)
signal set_max_stamina(max_stamina)

# HEALING
signal start_healing()

# CLOUD JUMP
signal cloud_jump()

#WALL SLIDE
#signal _wall_slide_start()
#signal _wall_slide_end()

#INCREASE JUMP COUNT
signal add_jump_max()
signal reset_jump_maxd()

#SHOW THE FROG
signal show_the_frog(jump_max: int)

# SET BOX ACTIVE/INACTIVE
signal player_in_box(in_box: bool)

# SET PLAYER POSITION
signal set_player_position()
signal player_dead()

# If player dies and needs a reset (kill wall for example)
signal death_reset()

# DOUGNUT POINTS
signal doughnut_points()
# DOUGHNUT UI
signal found_doughnut_hud(nro: int)
#VICTORY
signal victoryDoughnuts()
# HELP NPC EXCLAMATION MARK
signal show_exclamation()

#PLAYER SINKING
signal  player_sink(sink: bool)

#INFOTEXT 
signal show_info_text(text: String)
signal hide_info_text_icon()

#TELEPORT PLAYER
signal teleport_player(x,y)

#BOX HIDE
signal hide_box(box_number: int)

#WORM HURT
signal worm_hurt()

#DASH SPECIAL OBJECT
signal special_object()

#CHANGE music
signal change_music(music_name)
signal audio_stop_play(value: bool)

# Hide all info board
signal hide_all_info_boards

#Change backround color
signal change_backround_color(color_code)

#Cake Gems
signal show_cake_gems()

#when game starts sets cake doughnuts transparent
signal cake_doughnuts_transparent()



