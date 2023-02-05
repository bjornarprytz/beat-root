extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var m = load("res://assets/mp3/music.mp3")
# Called when the node enters the scene tree for the first time.
func _ready():
	stream = m
	play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
