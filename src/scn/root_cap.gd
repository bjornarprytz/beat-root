extends KinematicBody2D


var velocity = Vector2()
var random_factor = 0.3
var random_interval = 1.0
var time_since_last_random = 0.0
var path = Path2D.new()
var score = 0

func _ready():
	set_process(true)
	path.set_material(get_node("LineMaterial"))

func _process(delta):
	velocity = move_and_slide(velocity)
	time_since_last_random += delta
	if time_since_last_random > random_interval:
		time_since_last_random = 0.0
		velocity += Vector2(rand_range(-random_factor, random_factor), rand_range(-random_factor, random_factor))
	path.add_point(get_position())

func _on_Area2D_body_entered(body):
	if body.is_in_group("table"):
		velocity = velocity.bounce(body.get_contact_normal(get_rid()))
