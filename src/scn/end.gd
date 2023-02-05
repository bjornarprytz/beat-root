extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var game_manager = get_node("/root/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	var score = 0
	if (game_manager.shots == 0):
		score = 9999999
	else:
		score = game_manager.score / game_manager.shots
	
	$Scoreboard/Score.text = str(score)

