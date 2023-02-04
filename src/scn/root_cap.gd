extends Node2D

onready var spawner = load("res://scn/root_cap.tscn")

const drawTrailInterval = 0.08
const generationDecayFactor = 0.9
const friction = 0.4
const chaosInterval = 0.1
const chaos = 0.98

var distanceTravelled = 0.0
var energy = 0.0
var drawTrailTimeLeft = drawTrailInterval
var chaosTimeLeft = chaosInterval

var direction = Vector2()

var benign = false
var started = false
var entropy = 0.0
var stability = 6 # Dont make it 0 :(
var momentum = 50.0

onready var trail = get_node("Trail")
onready var body = get_node("Body")

func _ready():
	trail.add_point(Vector2(0.0,0.0))

func _physics_process(delta):
	var velocity = body.move_and_slide(direction * momentum * delta)
	
	body.position += velocity
	
	var distance = velocity.length()
	distanceTravelled += distance
	energy += distance

func _process(delta):
	if !started:
		return

	if !benign && energy > (50.0 + (entropy * 120.0)):
		spawn_child(false)
		
	drawTrailTimeLeft -= delta
	if drawTrailTimeLeft < 0.0:
		drawTrailTimeLeft = drawTrailInterval
		trail.add_point(body.position)
	
	if randf() > chaos:
		var loss = randf() * friction
		momentum = max((momentum - loss), 0.0)
		
		if momentum == 0.0:
			started = false
			print(distanceTravelled)
		
	if randf() > chaos:
		var random_angle = rand_range(-PI / stability, PI / stability)
		set_direction(direction.rotated(random_angle))
	

func _input(event):
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		started = true
		# Get the mouse position
		var mouse_position = event.position
		var node_position = global_position
		# Calculate the direction vector from the node to the mouse position
		set_direction(mouse_position - node_position)
		


func set_direction(vector):
	direction = vector.normalized()
	if direction.y < 0:
		direction.y = -direction.y
		
func spawn_child(benign_root):
	var child = spawner.instance()
	add_child(child)
	
	if benign_root:
		child.benign = true
		child.trail.default_color = Color.gray
		child.trail.width = trail.width * 0.5
		
	else:
		energy = 0
		entropy += (0.3 * randf())
		var decay = generationDecayFactor + (( randf() * 0.2 ) - 0.4)
		
		child.entropy = entropy + randf()
		child.stability = stability * decay
		child.momentum = momentum * decay
	
	child.position = body.position
		
	var random_angle = rand_range(-PI /4 , PI /4)
	child.set_direction(direction.rotated(random_angle))
	child.started = true
