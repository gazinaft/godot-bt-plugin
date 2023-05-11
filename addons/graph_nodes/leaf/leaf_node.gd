@tool
class_name LeafNode
extends PanelContainer

signal connection_start(l: LeafNode)
signal connection_end(l: LeafNode)

@onready var draggable_node: DraggableNode = $Draggable

func _get_anchor_for_children():
	return position + Vector2(size.x/2, size.y)

func _get_anchor_for_parents():
	return position + Vector2(size.x/2, 0)

func _on_drag_start():
	print("Leaf node start send event connection " + self.name)
	connection_start.emit(self)

func _on_drag_release():
	print("Leaf node end send event connection " + self.name)
	connection_end.emit(self)

# Called when the node enters the scene tree for the first time.
func _ready():
	$VSplitContainer/Control/Button.button_down.connect(_on_drag_start)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_gui_input(event):
	if event is InputEventMouseButton:
		print(event)
		if not event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
			_on_drag_release()
