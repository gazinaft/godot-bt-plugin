@tool
class_name DraggableNode
extends Node

@export_node_path("Control", "NodeRect") var rect_path

var rect 

var is_being_dragged = false

signal moved

func _ready():
	rect = get_node(rect_path)

func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		var mButton = event as InputEventMouseButton
		if mButton.button_index == MOUSE_BUTTON_MASK_LEFT and mButton.pressed:
			is_being_dragged = true
		elif mButton.button_index == MOUSE_BUTTON_MASK_LEFT and !mButton.pressed:
			is_being_dragged = false
	if event is InputEventMouseMotion and is_being_dragged:
		var node_to_move = get_parent()
		move_node(get_parent(), event)

		get_node(GraphAutoload.PATH)._get_parallel_tree_node(get_parent().get_parent()).position = get_parent().position


func move_node(node_to_move: Control, move: InputEventMouseMotion):
	node_to_move.position += move.relative
	node_to_move.position.x = clamp(node_to_move.position.x, 0, get_viewport().size.x - rect.size.x)
	node_to_move.position.y = clamp(node_to_move.position.y, 0, get_viewport().size.y - rect.size.y)
	moved.emit(move.relative)
