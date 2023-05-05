@tool
extends EditorPlugin

const GraphCanvas = preload("res://addons/canvas/graph_canvas.tscn")
var graph_canvas_instance

func _enter_tree():
	instantiate_canvas()
	register_autoload()
	register_custom_types()


func _exit_tree():
	if graph_canvas_instance:
		unload_plugin()


func _has_main_screen():
	return true


func _edit(object):
	var space = object as GridSpace
	if space == null:
		return

	var duplicate = space.duplicate(DUPLICATE_USE_INSTANTIATION)
	get_node(GraphAutoload.PATH).edit_space(space, duplicate)
	


func  _handles(object):
	return object is GridSpace# or object is BaseLeaf


func _make_visible(visible):
	print("IM VISIBLE")
	if graph_canvas_instance:
		graph_canvas_instance.visible = visible
		update_overlays()


func _get_plugin_name():
	return "AI Graph"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")


func instantiate_canvas():
	graph_canvas_instance = GraphCanvas.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(graph_canvas_instance)
	_make_visible(false)


func register_custom_types():
	add_custom_type("GridSpace", "Control", preload("res://addons/canvas/grid_space/grid_space.gd"), preload("res://icon.svg"))
	#add_custom_type("BaseLeaf", "Control", preload("res://addons/graph_nodes/leaf/base_leaf.gd"), preload("res://icon.svg"))


func register_autoload():
	add_autoload_singleton(GraphAutoload.NAME, "res://addons/autoload/graph_autoload.gd")
	var ga = get_node(GraphAutoload.PATH)
	ga._editor_interface = get_editor_interface()
	ga._graph_canvas = graph_canvas_instance
	add_autoload_singleton(ConnectionManagerAutoload.NAME, "res://addons/autoload/connection_manager_autoload.gd")
	var cma = get_node(ConnectionManagerAutoload.PATH)
	

func unload_plugin():
	graph_canvas_instance.queue_free()
	remove_custom_type("GridSpace")
	#remove_custom_type("BaseLeaf")
	remove_autoload_singleton(GraphAutoload.NAME)
	remove_autoload_singleton(ConnectionManagerAutoload.NAME)