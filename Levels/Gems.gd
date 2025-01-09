extends Node

@onready var gem_count = self.get_child_count()

# Called when the node enters the scene tree for the first time.
func _ready():
	Global.total_gem_amount = gem_count

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass
