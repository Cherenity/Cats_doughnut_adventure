extends Area2D
 
var can_enter = false
var door_entered = false

@export var needed_points_to_enter = 0
@export var x = -160
@export var y = -74
@export var nro = 0
@onready var doors_animation = $AnimatedSprite2D
@onready var door_details = $Board/DoorDetails


func _ready():
	doors_animation.play("PortalBlack")	

func _process(_delta):
	if not can_enter:
		return
	if Input.is_action_just_pressed("ui_accept") and not door_entered:
		door_entered = true
		if nro == 2:
			#not last song 2nd last
			Events.change_music.emit("last_song")
		Events.teleport_player.emit(x, y)

func _on_body_entered(body):
	if self.name == "Door2" and Global.level_complete:
		return
	if body.name == "Player":
		if needed_points_to_enter > Global.total_points:
			$Board.visible = true
			door_details.text = "Points required\n" +  str(needed_points_to_enter)

		else:
			$Board.visible = true
			door_details.text = "Press Enter"

	if body.name == "Player":
		if needed_points_to_enter <= Global.total_points:
			can_enter = true

func _on_body_exited(body):
	$Board.visible = false
	if body.name =="Player" and can_enter:
		doors_animation.play("Portal1")
	can_enter = false

