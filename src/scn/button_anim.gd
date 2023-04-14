extends TextureButton


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

const pulse_speed = 1.0

var grow = false

var interval = pulse_speed

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	interval -= delta
	
	if (interval < 0):
		interval = pulse_speed
		grow = !grow
	
	var targetScale = Vector2(1.0,1.0)
	if grow:
		targetScale = Vector2(1.2,1.2)
	else:
		targetScale = Vector2(0.8,0.8)

	scale = lerp(scale, targetScale, delta)
	#rect_scale.x = lerp(rect_scale.x, targetScale, delta)
	#rect_scale.y = lerp(rect_scale.y, targetScale, delta)
