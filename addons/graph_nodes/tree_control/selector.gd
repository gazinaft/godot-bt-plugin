@tool
class_name Selector
extends Control

var scene = preload("res://addons/graph_nodes/tree_control/selector.tscn")

var leaf: Node

func _enter_tree():
	_hide.call_deferred()


func _ready():
	if not get_node(GraphAutoload.PATH).apply_changes.is_connected(on_changes_applied):
		get_node(GraphAutoload.PATH).apply_changes.connect(on_changes_applied)

	if get_child_count(true) == 0 and leaf == null:
		leaf = scene.instantiate()
		add_child(leaf, false, INTERNAL_MODE_BACK)


func _hide():
	leaf = get_child(0, true)
	remove_child(leaf)
	
	add_child(leaf, false, INTERNAL_MODE_FRONT)
	

func _exit_tree():
	leaf.owner = get_parent() 


func on_changes_applied():
	leaf.owner = get_parent() 
	_hide.call_deferred()
