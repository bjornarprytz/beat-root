extends Node2D


@onready var game_manager = get_node("/root/GameManager")

func _ready():
	var score = 0
	if (game_manager.shots == 0):
		score = 9999999
	else:
		score = game_manager.score / game_manager.shots
	
	$Scoreboard/Score.text = str(score)
	
	# TODO: base on score
	$PlantLevel1.visible = false
	$PlantLevel2.visible = false
	
	if game_manager.loss:
		$PlantLevel3.visible = false
	else:
		$BigBeanLevel0.visible = false

