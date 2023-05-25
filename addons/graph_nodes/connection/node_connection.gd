@tool
extends Control
class_name NodeConnection

@export_node_path() var parent_base: NodePath
var parent: Control
@export_node_path() var child_base: NodePath
var child: Control
var grph_autoload: GraphAutoload

@onready var line_conn: LineConnection2D = $Line
@export var is_connected: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	line_conn = get_node("Line")
	grph_autoload = get_node(GraphAutoload.PATH) as GraphAutoload
	if is_connected and grph_autoload.is_in_canvas_tree(self):
		var tree_conn = grph_autoload._get_parallel_tree_node(self)
		parent = grph_autoload._get_parallel_canvas_node(tree_conn.get_node(parent_base)).get_node("LeafNode")
		child = grph_autoload._get_parallel_canvas_node(tree_conn.get_node(child_base)).get_node("LeafNode")
		_set_up_follow()
	request_ready()

func _process(delta):
	if grph_autoload.is_in_scene_tree(self) and not grph_autoload._get_parallel_canvas_node(self):
		grph_autoload._get_parallel_canvas_node(get_parent()).add_child(self.duplicate())

	if grph_autoload.is_in_canvas_tree(self):
		if (parent == null or child == null) and is_connected:
			get_parent().remove_child(self)
			queue_free()
	else:
		if not (has_node(parent_base) and has_node(child_base)) and is_connected:
			get_parent().remove_child(self)
			queue_free()


func _start_connection(p: Control):
	parent = p
	line_conn.point_a.position = parent._get_anchor_for_children()

	line_conn.point_b.position = get_local_mouse_position()
	p.draggable_node.moved.connect(func(x): line_conn.point_a._on_follow_point_moved(x))
	
	line_conn.adjust_sigmoid()


func _end_connection(c: Control):
	child = c
	line_conn.point_b.position = child._get_anchor_for_parents()
	
	child.draggable_node.moved.connect(func(x): line_conn.point_b._on_follow_point_moved(x))


func _exit_tree():
	if grph_autoload.is_in_scene_tree(self):
		var bl = grph_autoload._get_parallel_canvas_node(self)
		bl.get_parent().remove_child(bl)
		bl.queue_free()


func _input(event):
	if event is InputEventMouseMotion and !is_connected:
		var motion = event as InputEventMouseMotion
		line_conn.point_b._on_follow_point_moved(motion.relative/grph_autoload._graph_canvas.camera.zoom)


func _set_up_follow():
	line_conn.point_b.position = child._get_anchor_for_parents()
	child.draggable_node.moved.connect(func(x): line_conn.point_b._on_follow_point_moved(x))
	line_conn.point_a.position = parent._get_anchor_for_children()
	parent.draggable_node.moved.connect(func(x): line_conn.point_a._on_follow_point_moved(x))
	line_conn.adjust_sigmoid()


