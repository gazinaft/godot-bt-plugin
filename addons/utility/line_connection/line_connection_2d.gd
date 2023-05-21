@tool
class_name LineConnection2D
extends Control

@onready var sigmoid: Sigmoid = $Sigmoid
@onready var point_a: NamedPoint = $PointA
@onready var point_b: NamedPoint = $PointB

func _ready():
	adjust_sigmoid()
	point_a.point_moved.connect(adjust_sigmoid)
	point_b.point_moved.connect(adjust_sigmoid)

func adjust_sigmoid():
	var b_pos = point_b.position + Vector2(15, 15)
	var a_pos = point_a.position + Vector2(15, 15)

	var dir = a_pos - b_pos
	var origin = b_pos + dir / 2

	sigmoid.position = origin
	sigmoid.sigmoid_scale = abs(dir)

	if (b_pos.y >= a_pos.y and b_pos.x > a_pos.x) or (b_pos.y < a_pos.y and b_pos.x < a_pos.x):
		sigmoid.rotation_angle = 90
		sigmoid.sigmoid_scale.y /= 2
	else:
		sigmoid.rotation_angle = 0
		sigmoid.sigmoid_scale.x /= 2

