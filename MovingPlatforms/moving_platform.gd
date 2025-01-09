extends AnimatableBody2D

var platform_moving = false

@onready var animation = $AnimationPlayer
var entered = false
var cleared = false
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Global.total_points == 100:
		go_down()
		cleared = true



func go_up():
	if not platform_moving and not entered:
		platform_moving = true
		entered = true
		animation.play("go_up")
		await get_tree().create_timer(0.5).timeout 
		platform_moving = false
	
		
func go_down():
	if platform_moving == false:
		platform_moving = true
		$stopPlayer.set_deferred("disabled", true)
		animation.play("go_down")


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		if not cleared:
			$stopPlayer.set_deferred("disabled", false)
			go_up()
