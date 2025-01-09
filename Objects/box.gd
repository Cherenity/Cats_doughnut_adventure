extends AnimatableBody2D

@onready var timer_node = $Timer
@export var box_nro = 0

var in_box = false
# Called when the node enters the scene tree for the first time.
func _ready():
	Events.hide_box.connect(hide_self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_player_enter_area_body_entered(body):
	if body.name == ("Player") and not in_box:
		$AnimationPlayer.play("box_enter")
		Events.player_in_box.emit(true)
		self.hide()
		timer_node.start()
		in_box = true

func _on_timer_timeout():
	Events.player_in_box.emit(false)
	in_box = false	
	Events.audio_stop_play.emit(true)
	self.show()

# PITÄÄ VIEL KATTOO ET OIKEE BOXI NYT POISTAA KAIKKI
func hide_self(boxNro):
	if box_nro == boxNro:
		self.queue_free()

	
