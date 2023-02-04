extends Node2D

onready var spawner = load("res://scn/root_cap.tscn")

var distanceTravelled = 0.0
var energy = 0.0

var direction = Vector2()

var chaos = 0.97


var started = true
var stability = 8 # Dont make it 0 :(
var momentum = 50.0

var friction = 10.0

onready var trail = get_node("Trail")
onready var body = get_node("Body")

func _process(delta):
	if !started:
		return

	var velocity = direction * momentum * delta
	velocity = body.move_and_slide(velocity)
	
	body.position += velocity
	trail.add_point(body.position)
	
	var distance = velocity.length()
	distanceTravelled += distance
	energy += distance
	
	if energy > 100.0:
		energy = 0
		var child = spawner.instance()
		child.position = body.position
		child.direction = direction.rotated(PI / 4)
		child.started = true
		add_child(child)
		print("Spawned new!")
		
	
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
		# Get the mouse position
		var mouse_position = event.position
		var node_position = global_position
		# Calculate the direction vector from the node to the mouse position
		direction = (mouse_position - node_position).normalized()
		if direction.y < 0:
			direction = -direction
