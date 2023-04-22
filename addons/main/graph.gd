@tool
extends EditorPlugin

const GraphCanvas = preload("res://addons/canvas/graph_canvas.tscn")
var graph_canvas_instance

func _enter_tree():
	graph_canvas_instance = GraphCanvas.instantiate()
	graph_canvas_instance.editor_interface = get_editor_interface()
	graph_canvas_instance.viewport = get_editor_interface().get_edited_scene_root().get_parent()
	get_editor_interface().get_editor_main_screen().add_child(graph_canvas_instance)
	_make_visible(false)


func _exit_tree():
	if graph_canvas_instance:
		graph_canvas_instance.queue_free()


func _has_main_screen():
	return true


func _make_visible(visible):
	if graph_canvas_instance:
		graph_canvas_instance.visible = visible
		update_overlays()


func _get_plugin_name():
	return "AI Graph"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")