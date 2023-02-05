extends Node2D

export var is_main = false
onready var spawner = load("res://scn/root_cap.tscn")
onready var game_manager = get_node("/root/GameManager")

const drawTrailInterval = 0.08
const generationDecayFactor = 0.9
const friction = 1.2
const lossInterval = 0.1
const chaos = 0.98


var distanceTravelled = 0.0
var energy = 0.0
var drawTrailTimeLeft = drawTrailInterval
var lossCountdown = lossInterval

var direction = Vector2()

var is_aiming = false
var benign = false
var started = false
var entropy = 0.0
var stability = 6 # Dont make it 0 :(
var momentum = 50.0

var aim_line: Line2D

onready var trail = get_node("Trail")
onready var body = get_node("Body")
onready var button = get_node("Body/Button")

func _ready():
	trail.add_point(Vector2(0.0,0.0))

func _physics_process(delta):
	if !started:
		return
	var velocity = body.move_and_slide(direction * momentum * delta)
	
	body.position += velocity
	
	var distance = velocity.length()
	distanceTravelled += distance
	energy += distance

func _process(delta):
	
	if is_aiming:
		if aim_line.get_point_count() > 1:
			aim_line.remove_point(1)
			
		var start = aim_line.get_point_position(0)
		var end = get_global_mouse_position() - position - body.position
		aim_line.add_point(end)
		var strength = (start-end).length()
		if (strength  < 100.0):
			aim_line.default_color = Color.green
		if (strength >= 100.0 and strength < 200.0):
			aim_line.default_color = Color.yellow
		if (strength >= 200.0):
			aim_line.default_color = Color.red
	
	if !started:
		return

	if !benign && energy > (30.0 + (entropy * 10.0)):
		spawn_child(false)
		
	drawTrailTimeLeft -= delta
	if drawTrailTimeLeft < 0.0:
		drawTrailTimeLeft = drawTrailInterval
		trail.add_point(body.position)
	
	lossCountdown -= delta
	if lossCountdown < 0:
		lossCountdown = lossInterval
		var loss = randf() * friction
		momentum = max((momentum - loss), 0.0)
		
		if momentum == 0.0:
			started = false
			game_manager.score += distanceTravelled
			if (is_main):
				button.visible = true
		
		var random_angle = rand_range(-PI / stability, PI / stability)
		set_direction(direction.rotated(random_angle))

func _input(event):
	if !is_aiming:
		return
	
	if (event.is_pressed() and event.button_index == BUTTON_LEFT):
		started = true
		# Get the mouse position
		var mouse_position = event.position
		var node_position = global_position
		# Calculate the direction vector from the node to the mouse position
		var start_vector = mouse_position - node_position
		set_direction(start_vector)
		var strength = start_vector.length()
		aim_line.free()
		is_aiming = false
		
		
		if (strength  < 100.0):
			momentum = 20.0
			stability = 24
			entropy -= 0.2
		if (strength >= 100.0 and strength < 200.0):
			momentum = 40.0
			stability = 12
		if (strength >= 200.0):
			momentum = 70.0
			stability = 8
			entropy += 0.2
		
		set_direction(start_vector)
		

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
	child.button.hide()

func _on_button_pressed():
	button.hide()
	
	is_aiming = true
	aim_line = Line2D.new()
	aim_line.width = 1.0
	body.add_child(aim_line)
	aim_line.add_point(Vector2(0,0))

func _on_Area2D_area_entered(area):
	energy += 100.0
	area.get_parent().queue_free()

func _on_WinCheck_area_entered(area):
	get_tree().change_scene("res://scn/end.tscn")
	pass
	# TODO: Win screen
	

func _on_LossCheck_area_entered(area):
	print("loss")
	# TODO: Lose screen
