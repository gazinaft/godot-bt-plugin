extends Camera2D

@export var pan_gesture_strength: float = 3

@export var min_zoom: float = 1;
@export var max_zoom: float = 5;

signal zoom_changed

func _input(event: InputEvent):
	if event is InputEventPanGesture:
		_input_pan_gesture(event)
	if event is InputEventMagnifyGesture:
		_input_magnify_gesture(event)


func _input_magnify_gesture(event: InputEventMagnifyGesture):
	zoom *= event.factor
	_clamp_camera()
	zoom_changed.emit(zoom.x, min_zoom, max_zoom)


func _input_pan_gesture(event: InputEventPanGesture):
	offset += pan_gesture_strength * event.delta
	_clamp_camera()


func _clamp_camera():
	zoom = clamp(zoom, Vector2(min_zoom, min_zoom), Vector2(max_zoom, max_zoom))
	offset.x = clamp(offset.x, 0, get_viewport().size.x - (get_viewport().size/zoom.x).x)
	offset.y = clamp(offset.y, 0, get_viewport().size.y - (get_viewport().size/zoom.x).y)
