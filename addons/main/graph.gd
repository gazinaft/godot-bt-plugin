@tool
extends EditorPlugin

const grphCanvas = preload("res://addons/canvas/graph_canvas.tscn")
var graph_canvas_instance: GraphCanvas
var grph_autoload: GraphAutoload

func _enter_tree():
	var editor_interface = get_editor_interface()
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
	await get_tree().process_frame
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


func _get_space(n):
	if n == null:
		return null
	if n is GridSpace:
		return n
	return _get_space(n.get_parent())

func _edit(object):
	if object != null and not _handles(object):
		get_node(GraphAutoload.PATH).edit_space(null)
		return

	var space = _get_space(object)
	
	get_node(GraphAutoload.PATH).edit_space(space)


func  _handles(object):
	return object is GridSpace or object is BaseLeaf or object is NodeConnection or object is BaseDecorator


func _make_visible(visible):
	if visible:
		graph_canvas_instance.show()
	else:
		graph_canvas_instance.hide()


func _get_plugin_name():
	return "AI Graph"


func _get_plugin_icon():
	return get_editor_interface().get_base_control().get_theme_icon("Node", "EditorIcons")


func instantiate_canvas():
	graph_canvas_instance = grphCanvas.instantiate()
	graph_canvas_instance.editor_interface = get_editor_interface()
	get_editor_interface().get_editor_main_screen().add_child(graph_canvas_instance)
	_make_visible(false)
	

func register_custom_types():
	add_custom_type("GridSpace", "Control", preload("res://addons/canvas/grid_space/grid_space.gd"), preload("res://circle-ai.png"))
	add_custom_type("BaseLeaf", "Control", preload("res://addons/graph_nodes/leaf/base_leaf.gd"), preload("res://circle-ai.png"))
	add_custom_type("BaseDecorator", "Control", preload("res://addons/graph_nodes/decorator/base_decorator.gd"), preload("res://circle-ai.png"))


func register_autoload():
	add_autoload_singleton(GraphAutoload.NAME, "res://addons/autoload/graph_autoload.gd")
	grph_autoload = get_node(GraphAutoload.PATH)
	grph_autoload._editor_interface = get_editor_interface()
	grph_autoload._graph_canvas = graph_canvas_instance
	scene_closed.connect(grph_autoload.remove_from_cache)
	add_autoload_singleton(ConnectionManagerAutoload.NAME, "res://addons/autoload/connection_manager_autoload.gd")


func unload_plugin():
	graph_canvas_instance.queue_free()
	remove_custom_type("GridSpace")
	remove_custom_type("BaseLeaf")
	remove_autoload_singleton(GraphAutoload.NAME)
	remove_autoload_singleton(ConnectionManagerAutoload.NAME)