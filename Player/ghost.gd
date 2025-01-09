extends Sprite2D

var start = 8
var end = 11
static var current = 8

func _ready():
	if current >= end:
		current = start
	frame = current
	current += 1
	ghosting()

func set_property(tx_pos):
	position = tx_pos
	position.y += -14
	
func set_flip(flip):
	flip_h = flip
	
func ghosting():
	var tween_fade = get_tree().create_tween()
	tween_fade.tween_property(self, "self_modulate",Color(1, 1, 1, 0),0.75)
	await tween_fade.finished
	queue_free()
