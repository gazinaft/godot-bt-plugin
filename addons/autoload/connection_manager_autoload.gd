@tool
class_name ConnectionManagerAutoload
extends Node

const NAME = "CMAutoload"
const PATH = "/root/" + NAME

var connection_scene = preload("res://addons/graph_nodes/connection/node_connection.tscn")
var active_conn: NodeConnection = null


var connected_leaves: Array = []

var grid: Node = null :
	set(value):
		if grid != null: 
			grid.child_entered_tree.disconnect(connect_leaf)
			# for leaf in connected_leaves.duplicate(false):
				# disconnect_leaf(leaf)
			connected_leaves = []
		grid = value
		get_leaf_nodes_from_tree(grid)
		connect_stored_leaves()
		grid.child_entered_tree.connect(connect_leaf)
		print("grid set in autoload")			

func get_leaf_nodes_from_tree(st: Node):
	find_by_class(st, connected_leaves)

func connect_stored_leaves():
	for l in connected_leaves:		
		l.connection_start.connect(_start_connection)
		l.connection_end.connect(_end_connection)
		print("connected leafnode " + l.name)

func connect_leaf(l: Node):
	if l is LeafNode:
		connected_leaves.append(l)
		l.connection_start.connect(_start_connection)
		l.connection_end.connect(_end_connection)
		print("connected leafnode " + l.name)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func find_by_class(node: Node, result : Array) -> void:
	if node is LeafNode :
		result.push_back(node)
		print("found ", node.name)
	for child in node.get_children():
		find_by_class(child, result)


func _start_connection(start: LeafNode):
	print("CM start connection")
	active_conn = connection_scene.instantiate()
	print("scene instantiated")
	grid.add_child(active_conn)
	print("child added")
	active_conn._start_connection(start)	

func _end_connection(end: LeafNode):
	print("CM end connection")
	if active_conn == null:
		return
	active_conn._end_connection(end)
	active_conn = null

func _end_invalid():
	print("CM invalid connection start")
	if active_conn == null:
		return
	print("CM invalid delete node")
	grid.remove_child(active_conn)
	active_conn.queue_free()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
