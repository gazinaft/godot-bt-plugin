@tool
extends EditorPlugin

const grphCanvas = preload("res://addons/canvas/graph_canvas.tscn")
var graph_canvas_instance: GraphCanvas

func _enter_tree():
	instantiate_canvas()
	register_autoload()
	register_custom_types()


func _apply_changes():
	get_node(GraphAutoload.PATH).apply_changes.emit()


func _exit_tree():
	if graph_canvas_instance:
		unload_plugin()


func _has_main_screen():
	return true


func _edit(object):
	if object != null and not _handles(object):
		return

	print("EDITING:",object)
	var get_space = func (n):
		if n == null:
			return null
		if n is GridSpace:
			return n
		return n.get_parent()

	var space = get_space.call(object)
	
	get_node(GraphAutoload.PATH).edit_space(space)


func _get_state()->Dictionary:
	return graph_canvas_instance.get_state()


func _set_state(state):
	graph_canvas_instance.set_state(state)



func  _handles(object):
	return object is GridSpace or object is BaseLeaf


func _make_visible(visible):
	if graph_canvas_instance:
		graph_canvas_instance.visible = visible
		update_overlays()


func _get_plugin_name():
	return "AI Graph"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")


func instantiate_canvas():
	graph_canvas_instance = grphCanvas.instantiate()
	get_editor_interface().get_editor_main_screen().add_child(graph_canvas_instance)
	_make_visible(false)


func register_custom_types():
	add_custom_type("GridSpace", "Control", preload("res://addons/canvas/grid_space/grid_space.gd"), preload("res://circle-ai.png"))
	add_custom_type("BaseLeaf", "Control", preload("res://addons/graph_nodes/leaf/base_leaf.gd"), preload("res://circle-ai.png"))


func register_autoload():
	add_autoload_singleton(GraphAutoload.NAME, "res://addons/autoload/graph_autoload.gd")
	var ga = get_node(GraphAutoload.PATH)
	ga._editor_interface = get_editor_interface()
	ga._graph_canvas = graph_canvas_instance
	scene_closed.connect(ga.remove_from_cache)


func unload_plugin():
	graph_canvas_instance.queue_free()
	remove_custom_type("GridSpace")
	remove_custom_type("BaseLeaf")
	remove_autoload_singleton(GraphAutoload.NAME)
	remove_autoload_singleton(ConnectionManagerAutoload.NAME)