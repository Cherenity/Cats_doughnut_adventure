extends Area2D

@export var info_text = ""
var show_board = false
@export var early_info = false
@export var final_info = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.play("open")
	Events.hide_all_info_boards.connect(hide_info_board)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func _on_body_entered(body):
	if body.name == "Player":
		if not show_board:
			Events.show_info_text.emit(info_text, true)
			show_board = true
	
func _on_body_exited(body):
	show_board = false
	if body.name == "Player" and not show_board:
		await get_tree().create_timer(0.7).timeout
		Events.show_info_text.emit("", false)

func hide_info_board():
	if not Global.level_complete:
		if early_info == true and final_info == false:
			self.queue_free()
		elif final_info == true:
			info_text = ""
			self.hide()
	else:
		if final_info == true:
			self.show()
			info_text = "Congratulations! You've completed the game."
		else:
			self.queue_free()
	
