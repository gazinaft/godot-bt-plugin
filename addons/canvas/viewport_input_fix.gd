@tool
extends SubViewportContainer

func _on_gui_input(event:InputEvent):
	$SubViewport.push_input(event, true)
