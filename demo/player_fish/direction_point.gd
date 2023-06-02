extends Sprite2D
class_name DirectionPoint

@export var radius = 200;

var direction: Vector2:
	get:
		return position.normalized()


func _process(delta):
	if Input.is_action_pressed("right"):
		var dir: Vector2 = (global_position - get_parent().global_position).normalized()
		dir = dir.rotated(PI*delta*1.5)
		global_position = get_parent().position + dir * radius * get_parent().scale.x
	if Input.is_action_pressed("left"):
		var dir: Vector2 = (global_position - get_parent().global_position).normalized()
		dir = dir.rotated(-PI*delta*1.5)
		global_position = get_parent().position + dir * radius * get_parent().scale.x
