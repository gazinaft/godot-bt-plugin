extends PanelContainer
class_name LeafNode

signal connection_start(l: LeafNode)
signal connection_end(l: LeafNode)


func _get_anchor_for_children():
	return position + Vector2(size.x/2, size.y)

func _get_anchor_for_parents():
	return position + Vector2(size.x/2, 0)


func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			_on_drag_release()
			get_viewport().set_input_as_handled()

func _on_drag_release():
	connection_end.emit(self)

func _on_drag_start():
	connection_start.emit(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	$VSplitContainer/Control/Button.pressed.connect(_on_drag_start)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
