extends CanvasLayer
var all_gems_collected = false
var gems_complete_text = ""
var stamina_label = ""
var elapsed_time: float = 0.0 # Variable to store elapsed time

var level_complete  = false


func _ready():
	Events.doughnut_points.connect(setPoints)
	Events.found_doughnut_hud.connect(showDoughnut)
	elapsed_time = 0.0
	

#func level(num):
	#$CurrentLevel.text = "Level: " + str(num)

func _process(delta):
	if not level_complete:
		elapsed_time += delta
	else:
		$TimeElapsed.show()
		$TimeElapsed.text = "Elapsed time: " + String("%.2f" % elapsed_time)



func gems(num):
	#var size =  get_tree().get_nodes_in_group("Gems").size()
	#var gems_left = get_tree().get_nodes_in_group("Gems")
	$GemsLabel.text = "Collected: " + str(num) + " | " + str(Global.total_gem_amount)
	$AnimatedSprite2D.play("default")
	$TotalPoints.text = "Points " + str(Global.total_points)

func setPoints():
	$TotalPoints.text = "Points " + str(Global.total_points)

func showDoughnut(nro):
	if nro == 0:
		$Doughnut0.self_modulate = Color(1,1,1,1)
		doughnutSpin($Doughnut0)
		
	elif nro == 1:
		$Doughnut1.self_modulate = Color(1,1,1,1)
		doughnutSpin($Doughnut1)
		
	elif nro == 2:
		$Doughnut2.self_modulate = Color(1,1,1,1)
		doughnutSpin($Doughnut2)
		
	elif nro == 3:
		$Doughnut3.self_modulate = Color(1,1,1,1)
		doughnutSpin($Doughnut3)
		
	elif nro == 4:
		$Doughnut4.self_modulate = Color(1,1,1,1)	
		doughnutSpin($Doughnut4)
		$LevelComplete.visible = true
		level_complete = true
		$HealthBar.hide()
		$StaminaBar.hide()
		

func doughnutSpin(doughnut):
	doughnut.scale = Vector2(3, 3)
	await get_tree().create_timer(2).timeout
	doughnut.scale = Vector2(2, 2)

