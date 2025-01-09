extends StaticBody2D
var entered = false
var text = "I can't turn back now. Doughnuts must be found."
var text_singal_done = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_r_area_body_entered(body):
		if body.name == "Player" and entered == false:
			entered = true
			call_deferred("_info_collision")
			call_deferred("_restrict_collision")

func _restrict_collision(): 
	$restrict_collision.disabled = false
func _info_collision():
	$info/info_collision.disabled = false

func _on_info_body_entered(body):
	if body.name == "Player" and not text_singal_done:
		text_singal_done = true
		Events.show_info_text.emit(text, true)

#signal show_info_text(text: String)
#signal hide_info_text_icon()

func _on_info_body_exited(body):
	if body.name == "Player":
		Events.show_info_text.emit("", false)
		text_singal_done = false
