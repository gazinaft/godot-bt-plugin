@tool
class_name ConnectionManagerAutoload
extends Node

const NAME = "CMAutoload"
const PATH = "/root/" + NAME

var connection_scene = preload("res://addons/graph_nodes/connection/node_connection.tscn")
var active_conn: NodeConnection = null

var from: Control

func connection_started(leaf: Control):
	from = leaf
	active_conn = connection_scene.instantiate()
	from.get_parent().add_child(active_conn)
	active_conn._start_connection(from)


func connection_ended():
	var grph_autload = get_node(GraphAutoload.PATH) as GraphAutoload
	print("over: ", grph_autload.mouse_over)
	if (grph_autload.mouse_over is Control) and grph_autload.mouse_over != from:
		active_conn._end_connection(grph_autload.mouse_over)
		sync_connection(grph_autload)
		from.get_parent().remove_child(active_conn)
		active_conn.queue_free()
	
	active_conn = null
	from = null


func sync_connection(grph_autload: GraphAutoload):
	var dup = connection_scene.instantiate() as NodeConnection
	dup.name = active_conn.parent.get_parent().name + "_" + active_conn.child.get_parent().name
	dup.is_connected = true
	
	grph_autload.edited_space_tree.add_child(dup)
	dup.owner = dup.get_parent()
	dup.parent_base = NodePath("../../" + grph_autload._get_space_path(grph_autload._get_parallel_tree_node(active_conn.parent.get_parent())))
	dup.child_base =  NodePath("../../" + grph_autload._get_space_path(grph_autload._get_parallel_tree_node(active_conn.child.get_parent())))