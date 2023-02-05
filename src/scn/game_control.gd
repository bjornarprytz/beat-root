extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"



func _input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		$AudioManager.start_knitre()
	
