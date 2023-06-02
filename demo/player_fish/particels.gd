extends GPUParticles2D

var body: Node2D

func _process(delta):
	if not body:
		body = get_parent().get_parent()
	
	if body.is_running:
		speed_scale = 3
	else:
		speed_scale = 2

