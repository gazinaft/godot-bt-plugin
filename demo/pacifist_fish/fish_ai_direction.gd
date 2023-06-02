extends Node2D
class_name FishAiDirection

var direction: Vector2:
	get:
		return position.normalized()

@export var radius = 200;

func _ready():
	var dir: Vector2 = (global_position - get_parent().global_position).normalized()
	dir = dir.rotated(randf_range(0, 2*PI))
	global_position = get_parent().position + dir * radius * get_parent().scale.x


func peacefull_direction(delta):
	print("CHANGE DIRECTION")
	var dir: Vector2 = (global_position - get_parent().global_position).normalized()
	dir = dir.rotated(sign(-5 + randi() % 10) * PI * delta * randi_range(20, 40))
	global_position = get_parent().position + dir * radius * get_parent().scale.x


func run_from_enemies(enemies, delta):
	print("RUN FROM ENEMIES")
	var dir: Vector2 = Vector2.ZERO
	for e in enemies:
		dir += global_position - e.global_position
	dir = dir.normalized()
	global_position = get_parent().position + dir * radius * get_parent().scale.x