extends Node2D

@export var fake_platform = false
@export var points_needed = 0
@export var first_platform = false
@onready var animation = $clearPlatformAnimatableBody/AnimationPlayer
@onready var points_text = $clearPlatformAnimatableBody/required
@export var add_closing = false

var cleared = false

# Called when the node enters the scene tree for the first time.
func _ready():
	if points_needed != 0:
		points_text.text = str(points_needed)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	if not fake_platform and not first_platform:
		if Global.total_points >= self.points_needed && cleared == false:
			#print(self.points_needed)
			animation.play("move")
			points_text.text = ""
			cleared = true
	elif not first_platform:
		if Global.total_points >= self.points_needed && cleared == false:
			#print(self.points_needed)
			self.visible = false
			$clearPlatformAnimatableBody/CollisionShape2D.disabled = true

	else:
		if Global.doughuts[0] == true && cleared == false:
			animation.play("move")
			cleared = true 
			
		


		
