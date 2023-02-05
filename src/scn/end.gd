extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
onready var game_manager = get_node("/root/GameManager")

# Called when the node enters the scene tree for the first time.
func _ready():
	print (game_manager.score)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
