extends Node

var gems_collected = 0
var total_points = 0
var dash_count = 3


#käytössä:
var doughuts = {0:false, 1:false, 2:false, 3:false, 4:false}

var level_complete = false
var total_gem_amount = 0 

var on_box = false
var player_jumping = false

var exploding_worms = []

# Called when the node enters the scene tree for the first time.
func _ready():
	pass
