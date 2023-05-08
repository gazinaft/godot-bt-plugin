@tool
extends Node

@export var pan_gesture_strength: float = 3

@export var min_zoom: float = 1;
@export var max_zoom: float = 5;
@export var mouse_delta_zoom: float = 0.03;

signal zoom_changed

const NODE_3D_VIEWPORT_CLASS_NAME = "Node3DEditorViewport"

var camera: Camera2D

var dragging = false

func _ready():
	camera = get_parent().get_node("Camera2D")
	camera.make_current()
	

func _input(event: InputEvent):
	if event is InputEventPanGesture:
		_input_pan_gesture(event)
	if event is InputEventMagnifyGesture:
		_input_magnify_gesture(event)
	if event is InputEventMouseButton:
		if (event.button_index == MOUSE_BUTTON_WHEEL_UP or event.button_index == MOUSE_BUTTON_WHEEL_DOWN) and event.pressed:
			_input_scroll(event)
		if event.button_index == MOUSE_BUTTON_MIDDLE:
			dragging = event.pressed
	if event is InputEventMouseMotion and dragging:
		_input_mouse_move_camera(event)

func _input_magnify_gesture(event: InputEventMagnifyGesture):
	var mouse_pos = get_viewport().get_mouse_position()
	if _camera_zoom_limit(event.factor > 1):
		return
	if event.factor > 1:
		camera.offset += (mouse_pos-camera.offset)*(event.factor-1)
	camera.zoom *= event.factor
	_clamp_camera()
	zoom_changed.emit(camera.zoom.x, min_zoom, max_zoom)


func _input_scroll(event: InputEventMouseButton):
	var scroll_up = event.button_index == MOUSE_BUTTON_WHEEL_UP
	var mouse_pos = get_viewport().get_mouse_position()
	if _camera_zoom_limit(scroll_up):
		return
	if scroll_up:
		camera.offset += (mouse_pos-camera.offset)*(mouse_delta_zoom)
		camera.zoom *= 1 + mouse_delta_zoom
	else:
		camera.offset -= camera.offset*(mouse_delta_zoom)
		camera.zoom /= 1 + mouse_delta_zoom
	_clamp_camera()
	zoom_changed.emit(camera.zoom.x, min_zoom, max_zoom)

func _input_pan_gesture(event: InputEventPanGesture):
	camera.offset += pan_gesture_strength * event.delta
	_clamp_camera()

func _input_mouse_move_camera(event: InputEventMouseMotion):
	camera.offset -= event.relative
	_clamp_camera()

func _clamp_camera():
	camera.zoom = clamp(camera.zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	camera.offset.x = clamp(camera.offset.x, 0, get_viewport().size.x - (get_viewport().size/camera.zoom.x).x)
	camera.offset.y = clamp(camera.offset.y, 0, get_viewport().size.y - (get_viewport().size/camera.zoom.x).y)
		

func _camera_zoom_limit(zoom_up: bool):
	return camera.zoom.x == max_zoom and zoom_up

func print_fucking_tree(node, tab:int):
	var s = ""
	for i in range(tab):
		s += "-"
	prints(s, node)
	for i in range(node.get_child_count()):
		print_fucking_tree(node.get_child(i), tab+1)
