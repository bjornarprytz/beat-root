extends Node2D

onready var spawner = load("res://scn/root_cap.tscn")

var distanceTravelled = 0.0
var energy = 0.0
var drawTrailInterval = 0.02
var drawTrailTimeLeft = 0.0

var direction = Vector2()

var chaos = 0.97


var started = false
var stability = 8 # Dont make it 0 :(
var momentum = 50.0

var friction = 10.0


onready var trail = get_node("Trail")
onready var body = get_node("Body")

func _process(delta):
	if !started:
		return

	if energy > 100.0:
		energy = 0
		var child = spawner.instance()
		add_child(child)
		var random_angle = rand_range(-PI /16, PI /16)
		child.direction = direction.rotated(random_angle)
		if child.direction.y < 0:
			child.direction = -child.direction
		child.started = true
		child.position = body.position
		print("Spawned new!")
		
	
	if drawTrailTimeLeft < 0.0:
		trail.add_point(body.position)
		drawTrailTimeLeft = drawTrailInterval
	
	var velocity = direction * momentum * delta
	velocity = body.move_and_slide(velocity)
	print(velocity)
	drawTrailTimeLeft -= delta
	body.position += velocity
	
	var distance = velocity.length()
	distanceTravelled += distance
	energy += distance
	
	if randf() > chaos:
		var loss = randf() / friction
		momentum = max((momentum - loss), 0.0)
		print(momentum)
		
		if momentum == 0.0:
			started = false
			print(distanceTravelled)
		
	if randf() > chaos:
		var random_angle = rand_range(-PI / stability, PI / stability)
		direction = direction.rotated(random_angle)
		if direction.y < 0:
			direction = -direction
	

func _input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		started = true
		# Get the mouse position
		var mouse_position = event.position
		var node_position = global_position
		# Calculate the direction vector from the node to the mouse position
		direction = (mouse_position - node_position).normalized()
		if direction.y < 0:
			direction = -direction
