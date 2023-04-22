@tool
extends Node

var is_being_dragged = false

func _on_gui_input(event:InputEvent):
	if event is InputEventMouseButton:
		var mButton = event as InputEventMouseButton
		if mButton.button_index == MOUSE_BUTTON_MASK_LEFT and mButton.pressed:
			is_being_dragged = true
		elif mButton.button_index == MOUSE_BUTTON_MASK_LEFT and !mButton.pressed:
			is_being_dragged = false
	if event is InputEventMouseMotion and is_being_dragged:
		var parent = (get_parent() as Control)
		var move = event as InputEventMouseMotion
		parent.position += move.relative
		parent.position.x = clamp(parent.position.x, 0, get_viewport().size.x - parent.size.x)
		parent.position.y = clamp(parent.position.y, 0, get_viewport().size.y - parent.size.y)
