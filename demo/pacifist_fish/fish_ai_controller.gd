extends Node2D
class_name FishAiController

var is_running: bool

var direction_point
@onready var animation: Node2D = $Animation

@export var max_speed: float = 20
@export var min_speed: float = 10
var speed = 0


func _ready():
	direction_point = get_node("Direction")
	animation.rotation = direction_point.direction.angle_to(Vector2.UP) - PI


func _process(delta):
	if is_running:
		speed = clamp(speed + 5*min_speed * delta, min_speed, max_speed)
	else:
		speed = clamp(speed - 5*min_speed * delta, min_speed, max_speed)
		
	position += direction_point.direction * speed * delta;
	var rot = lerp_angle(animation.rotation, direction_point.direction.angle() + PI, smoothstep(min_speed, max_speed, speed)*delta + 0.04)
	animation.rotation = rot
