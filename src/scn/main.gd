extends Node2D

var start_pos = Vector2(500, 200)
var end_pos = Vector2(500, 350)
var start_zoom = Vector2(.63, .63)
var end_zoom  = Vector2(.2, .2)
var current_pos = start_pos
var current_zoom = start_zoom
var pot = Vector2(420, 450)
var speed = 10
var zooming
var transition_duration = 0.5 # duration of the smooth transition in seconds
var transition_time = 0 # time elapsed during the smooth transition

# Called when the node enters the scene tree for the first time.
func _ready():
	zooming = true;

func _process(delta):
	var direction = (end_pos - current_pos).normalized()
	
	var velocity = direction * speed * delta
	current_pos += velocity
	
	$Camera2D.translate(velocity)
	
	if end_pos == pot:
		if abs(current_zoom.x - end_zoom.x) < 0.01:
			var ass = 1
		else:
			# Increase both the x and y components of the zoom level towards the end zoom
			var delta_zoom = (end_zoom - current_zoom) * delta * 5
			current_zoom += delta_zoom
			$Camera2D.zoom = current_zoom
	else:
		$Camera2D.zoom = Vector2(.63, .63)
		
	#$Camera2D.zoom
	
	if current_pos.distance_to(end_pos) < 1:
		current_pos = end_pos
		if current_pos == pot:
			get_tree().change_scene_to_file("res://scn/game.tscn")
		
	#$Camera2D.zoom = Vector2(.2, .2)
	#$Camera2D.position = Vector2(700, 450)
	

func _on_Button_pressed():
	end_pos = pot
	speed = 100
	#get_tree().change_scene("res://scn/game.tscn")
