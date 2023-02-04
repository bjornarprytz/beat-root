extends KinematicBody2D

var velocity = Vector2()
var score = 0
var speed = 1.0

onready var trail = get_node("../Trail")

func _process(delta):
	velocity = move_and_slide(velocity)
	
	position += velocity
	print(position)
	trail.add_point(position)

func _input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		# Get the mouse position
		var mouse_position = event.position
		var node_position = global_position
		# Calculate the direction vector from the node to the mouse position
		var direction = (mouse_position - node_position).normalized()
		# Ensure that the direction vector is always downwards
		if direction.y < 0:
			direction = -direction
		# Set the velocity of the node
		velocity = direction * speed
