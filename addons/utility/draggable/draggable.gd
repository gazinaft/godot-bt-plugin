@tool
extends Node

@export_node_path("Node", "NodeToMove") var node_to_move_path
@export_node_path("Control", "NodeRect") var rect_path

var rect 
var node_to_move

var is_being_dragged = false

signal moved

func _ready():
	node_to_move = get_node(node_to_move_path)
	rect = get_node(rect_path)

func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		var mButton = event as InputEventMouseButton
		if mButton.button_index == MOUSE_BUTTON_MASK_LEFT and mButton.pressed:
			is_being_dragged = true
		elif mButton.button_index == MOUSE_BUTTON_MASK_LEFT and !mButton.pressed:
			is_being_dragged = false
	if event is InputEventMouseMotion and is_being_dragged:
		var move = event as InputEventMouseMotion
		node_to_move.position += move.relative
		node_to_move.position.x = clamp(node_to_move.position.x, 0, get_viewport().size.x - rect.size.x)
		node_to_move.position.y = clamp(node_to_move.position.y, 0, get_viewport().size.y - rect.size.y)
		moved.emit()
