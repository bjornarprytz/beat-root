extends Node

onready var trail = $Trail
onready var trail = $Trail

var nextDraw = 1.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func _process(delta):
	nextDraw -= delta;
	
	if nextDraw < 0:
		trail.add_point()
