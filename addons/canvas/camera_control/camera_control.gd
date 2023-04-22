@tool
extends Node

@export var pan_gesture_strength: float = 3

@export var min_zoom: float = 1;
@export var max_zoom: float = 5;

signal zoom_changed

const NODE_3D_VIEWPORT_CLASS_NAME = "Node3DEditorViewport"

var camera: Camera2D

func _ready():
	camera = get_parent().get_node("Camera2D")
	camera.make_current()
	

func _input(event: InputEvent):
	if event is InputEventPanGesture:
		_input_pan_gesture(event)
	if event is InputEventMagnifyGesture:
		_input_magnify_gesture(event)


func _input_magnify_gesture(event: InputEventMagnifyGesture):
	var mouse_pos = get_viewport().get_mouse_position()
	if event.factor > 1:
		camera.offset += (mouse_pos-camera.offset)*(event.factor-1)
	camera.zoom *= event.factor
	_clamp_camera()
	zoom_changed.emit(camera.zoom.x, min_zoom, max_zoom)


func _input_pan_gesture(event: InputEventPanGesture):
	camera.offset += pan_gesture_strength * event.delta
	_clamp_camera()


func _clamp_camera():
	camera.zoom = clamp(camera.zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	camera.offset.x = clamp(camera.offset.x, 0, get_viewport().size.x - (get_viewport().size/camera.zoom.x).x)
	camera.offset.y = clamp(camera.offset.y, 0, get_viewport().size.y - (get_viewport().size/camera.zoom.x).y)
		

func print_fucking_tree(node, tab:int):
	var s = ""
	for i in range(tab):
		s += "-"
	prints(s, node)
	for i in range(node.get_child_count()):
		print_fucking_tree(node.get_child(i), tab+1)
