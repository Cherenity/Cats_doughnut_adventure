extends AudioStreamPlayer

var audio_path = "res://Music/gone_fishin_by_memoraphile_CC0.mp3"

var basic = "res://Music/gone_fishin_by_memoraphile_CC0.mp3"

var journey = "res://Music/CleytonRX - Battle RPG Theme.mp3"
var last_song = "res://Music/9-popsicle-cute-bgm-274660.mp3"

var happy_bday = "res://Music/happy-birthday-funk-spot-16197.mp3"
var strawberry = "res://Music/strawberry_cute.mp3"



var in_box = "res://Music/covert_action.ogg"




# Called when the node enters the scene tree for the first time.
func _ready():
	Events.change_music.connect(set_music)
	Events.audio_stop_play.connect(stop_or_play)
	var audio = load(audio_path)
	if audio is AudioStream: 
		self.stream = audio 
		self.play()
	else:
		print("Failed to load audio stream from path: ", audio_path)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_music(audio_name):
	if audio_name == "journey":
		audio_name = journey
		
	elif audio_name == "basic":
		audio_name = basic

	elif audio_name == "strawberry":
		audio_name = strawberry
		smooth_change()
		
	elif audio_name == "happy_bday":
		audio_name = happy_bday
		smooth_change()
		
	elif audio_name == "last_song":
		self.stop()
		await get_tree().create_timer(3).timeout
		audio_name = last_song
		smooth_change()

	var audio = load(audio_name)
	if audio is AudioStream: 
		self.stream = audio 
		self.play()

func stop_or_play(value):
	if value == false:
		self.stop()
	else:
		self.play()


func smooth_change():
	self.volume_db = -15 
	await get_tree().create_timer(4).timeout
	self.volume_db = -10 
	await get_tree().create_timer(3).timeout
	self.volume_db = -5 
	await get_tree().create_timer(2).timeout
	self.volume_db = 1 
	

