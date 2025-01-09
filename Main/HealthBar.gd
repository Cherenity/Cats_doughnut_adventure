extends TextureProgressBar

var reseting = false

func _ready():
	Events.set_current_health.connect(update_health_bar)
	Events.set_max_health.connect(set_max_health)

func update_health_bar(health):
	$".".value = health
	$healthnro.text = str(self.value)
	if self.value <= 3 and self.value > 1:
		$".".tint_progress = Color('97d284')
	elif self.value == 1:
		$".".tint_progress = Color('5c8c4d')
	else:
		$".".tint_progress = Color('c5eeb8')

func set_max_health(max_health):
	$".".max_value = max_health
