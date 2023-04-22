@tool
extends Node2D
const E = 2.7182

@export var step: float = 0.01 :
	set (value):
		step = value
		calc_points()
		queue_redraw()

@export var center: Vector2 = Vector2(0, 0.5) :
	set (value):
		center = value
		queue_redraw()

@export var line_width: float = 1 : 
	set (value):
		line_width = value
		queue_redraw()

@export var sigmoid_scale: Vector2 = Vector2.ONE :
	set (value):
		sigmoid_scale = value
		queue_redraw()

@export var rotation_angle: int = 0 :
	set (value):
		rotation_angle = value
		queue_redraw()


var points: Array

func sigmoid(x: float):
	return -1/(1+pow(E, -5*x)) 

func _ready():
	calc_points()

func _draw():
	for i in range(1, len(points)):
		var v1 = Vector2(points[i-1][0],  points[i-1][1])
		var v2 = Vector2(points[i][0], points[i][1])

		var matrix = Transform2D()
		matrix.origin = center
		matrix = matrix.rotated(deg_to_rad(rotation_angle))
		matrix = matrix.scaled(sigmoid_scale)
		
		draw_line(matrix*v1, matrix*v2, Color.DARK_RED, line_width)

func calc_points()->void:
	points = []
	for i in range(2/step):
		var coord = -1 + (step*i)
		points.append([coord, sigmoid(coord)])
