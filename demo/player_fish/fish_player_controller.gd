extends Node2D
class_name FishPlayer

@onready var direction_point: DirectionPoint = $Direction
@onready var animation: Node2D = $Animation

@export var max_speed: float = 20
@export var min_speed: float = 10

@export var attack_time: float = 0.5

var speed = 0
var is_running: bool
var attack_requested: bool
var is_attacking: bool

func _ready():
	animation.rotation = direction_point.direction.angle_to(Vector2.UP) - PI



func _process(delta):
	if is_running:
		speed = clamp(speed + 5*min_speed * delta, min_speed, max_speed)
	else:
		speed = clamp(speed - 5*min_speed * delta, min_speed, max_speed)
		
	
	position += direction_point.direction * speed * delta;
	if is_attacking:
		position += 2*direction_point.direction * max_speed * delta;

	var rot = lerp_angle(animation.rotation, direction_point.direction.angle() + PI, smoothstep(min_speed, max_speed, speed)*delta + 0.1)
	animation.rotation = rot

	if attack_requested:
		if is_attacking:
			attack_requested = false
			return
		
		is_attacking = true
		await get_tree().create_timer(attack_time).timeout
		is_attacking = false


func _input(event):
	if event.is_action_pressed("forward"):
		is_running = true
	if event.is_action_released("forward"):
		is_running = false
	if event.is_action_pressed("attack"):
		attack_requested = true


func _on_animation_body_entered(body):
	if body is Plankton:
		body.die = true
	scale += Vector2(0.05, 0.05)
