extends Area2D
var collected 
signal gem_collected
var keratty = false 
var points = 100
@export var animation = 1
@export var cake_gem = false

func _ready():
	Events.show_cake_gems.connect(show_cake_gems)
	if animation == 1:
		$AnimatedSprite2D.play("candy")
		points = 100
	elif animation == 2:
		$AnimatedSprite2D.play("melon")
		points = 200
	else:
		$AnimatedSprite2D.play("lollipop")
		points = 300

	#if self.name in Global.level_1_gems:
		#if Global.level_1_gems[self.name] == true:
			#self.monitoring = false
			#self.hide()

func _on_body_entered(body):
	if not collected and not Global.level_complete:
		if body.name == "Player":
			#if self.name in Global.level_1_gems:
				#Global.level_1_gems[self.name] = true

			Global.gems_collected += 1
			Global.total_points += points
			collected = true
			gem_collected.emit()
			$AudioStreamPlayer.play()
			hide()

func _on_collected_sfx_finished():
	if not cake_gem:
		queue_free()

func show_cake_gems():
	if cake_gem:
		show()
