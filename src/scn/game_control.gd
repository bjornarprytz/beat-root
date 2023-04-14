extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

func _ready():
	$RootCap.is_main = true

func _input(event):
	if (event.is_pressed() and event.button_index == MOUSE_BUTTON_LEFT):
		$AudioManager.start_knitre()
	
