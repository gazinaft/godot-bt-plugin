@tool
class_name ConnectionManagerAutoload
extends Node

const NAME = "CMAutoload"
const PATH = "/root/" + NAME

var connection_scene = preload("res://addons/graph_nodes/connection/node_connection.tscn")
var active_conn: NodeConnection = null

var from: LeafNode

func connection_started(leaf: LeafNode):
	from = leaf
	active_conn = connection_scene.instantiate()
	from.get_parent().add_child(active_conn)
	active_conn._start_connection(from)


func connection_ended():
	var grph_autload = get_node(GraphAutoload.PATH) as GraphAutoload
	print("over: ", grph_autload.mouse_over)
	if grph_autload.mouse_over is LeafNode and grph_autload.mouse_over != from:
		active_conn._end_connection(grph_autload.mouse_over)
		sync_connection(grph_autload)
	else:
		from.get_parent().remove_child(active_conn)
		active_conn.queue_free()
	
	active_conn = null
	from = null


func sync_connection(grph_autload: GraphAutoload):
	var dup = active_conn.duplicate() as NodeConnection

	grph_autload.edited_space_tree.add_child(dup)

	dup.owner = grph_autload.edited_space_tree
	dup.parent_base = grph_autload._get_parallel_tree_node(active_conn.parent.get_parent()).get_path()
	dup.child_base = grph_autload._get_parallel_tree_node(active_conn.child.get_parent()).get_path()
	dup.is_connected = true
	active_conn.is_connected = true