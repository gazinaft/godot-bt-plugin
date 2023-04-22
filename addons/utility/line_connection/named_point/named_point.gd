@tool
class_name NamedPoint
extends Node2D

const LETTERS = ['A', 'B', 'C', 'D', 'E']

func _ready():
	var p_count = -1
	for i in range(get_parent().get_child_count()):
		var child = get_parent().get_child(i)
		if child is NamedPoint:
			p_count += 1
	var label = get_node("Control/Label") as Label
	label.text = LETTERS[p_count]


func _on_texture_button_button_down():
	print("PRESSED")

func _on_texture_button_gui_input(event:InputEvent):
	print("PRESSED")
	event.se
