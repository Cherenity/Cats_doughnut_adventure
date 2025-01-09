extends TextureProgressBar


# Called when the node enters the scene tree for the first time.
func _ready():
	Events.set_max_stamina.connect(set_max_stamina)
	Events.stamina_changed.connect(set_stamina)

func set_max_stamina(max_stamina):
	$".".max_value = max_stamina

func set_stamina(max_stamina):
	$".".value = max_stamina
