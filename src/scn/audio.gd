extends AudioStreamPlayer2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"
var knitre = preload("res://assets/mp3/Knitre.mp3")
var knitre2 = preload("res://assets/mp3/Knitre 2.mp3")
var knitre3 = preload("res://assets/mp3/Knitre 3.mp3")
var knitre4 = preload("res://assets/mp3/Knitre 4.mp3")

var knitre_sounds = [knitre, knitre2, knitre3, knitre4]
var currentId = 0

var knitre_on = false

func _process(delta):
	if !knitre_on or playing:
		return
	
	currentId += 1
	
	if currentId == knitre_sounds.size():
		currentId = 0
	
	stream = knitre_sounds[currentId]
	stream.loop = false
	play()


func stop_knitre():
	knitre_on = false
	
func start_knitre():
	autoplay = false
	knitre_on = true
	currentId = 0
