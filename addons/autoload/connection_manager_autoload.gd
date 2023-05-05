@tool
class_name ConnectionManagerAutoload
extends Node

const NAME = "CMAutoload"
const PATH = "/root/" + NAME

var start_point: LeafNode = null
var end_point: LeafNode = null

func set_start(value):
	end_point = null
	start_point = value

func set_end(value):
	if start_point == null:
		return
	if start_point == value:
		start_point = null
		return
	end_point = value
	_create_connection(start_point, end_point)

var connected_leaves: Array = []

var sc_tree: SceneTree :
	set(value):
		for leaf in connected_leaves.duplicate(false):
			disconnect_leaf(leaf)
		sc_tree = value
		get_leaf_nodes_from_tree(sc_tree)			

func get_leaf_nodes_from_tree(st: SceneTree):
	find_by_class(st.root, "LeafNode", connected_leaves)

func connect_leaf(l: Node):
	if l is LeafNode:		
		connected_leaves.append(l)
		l.connection_start.connect(set_start)
		l.connection_end.connect(set_end)

func disconnect_leaf(l: Node):
	if l is LeafNode:
		connected_leaves.erase(l)
		l.connection_start.disconnect(set_start)
		l.connection_end.disconnect(set_end)

# Called when the node enters the scene tree for the first time.
func _ready():

	pass
	# get_tree().node_added.connect(connect_leaf)
	# get_tree().node_removed.connect(disconnect_leaf)
	
# func _set_start(start: LeafNode):
# 	end_point = null
# 	start_point = start

# func _set_end(end: LeafNode):
# 	if start_point == null:
# 		return
# 	if start_point == end:
# 		start_point = null
# 		return
# 	end_point = end
# 	_create(start_point, end_point)

func find_by_class(node: Node, className : String, result : Array) -> void:
	if node.is_class(className) :
		result.push_back(node)
	for child in node.get_children():
		find_by_class(child, className, result)

func _create_connection(start: LeafNode, end: LeafNode):
	var conn = NodeConnection.new()
	conn._connect_nodes(start, end)
	get_parent().add_child(conn)


# func _unhandled_input(event):
# 	if event is InputEventMouseButton:
# 		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
# 			start_point = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
