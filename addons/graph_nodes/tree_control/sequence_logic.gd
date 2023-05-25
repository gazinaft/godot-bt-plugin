@tool
class_name Sequence
extends Control

var scene = preload("res://addons/graph_nodes/tree_control/sequence.tscn")

var leaf: Node
var grph_autoload: GraphAutoload
var old_name: String

@export_file("*.gd") var leaf_logic

func _enter_tree():
	_hide.call_deferred()


func _ready():
	if not get_node(GraphAutoload.PATH).apply_changes.is_connected(on_changes_applied):
		get_node(GraphAutoload.PATH).apply_changes.connect(on_changes_applied)

	if get_child_count(true) == 0 and leaf == null:
		leaf = scene.instantiate()
		add_child(leaf, false, INTERNAL_MODE_BACK)

	leaf = get_child(0, true)
	leaf.get_node("VSplitContainer/Label").text = name
	old_name = name

	grph_autoload = get_node(GraphAutoload.PATH)
	if grph_autoload.is_in_scene_tree(self):
		renamed.connect(_on_renamed)


func _on_renamed():
	var label = leaf.get_node("VSplitContainer/Label")
	label.text = name
	var canvas_leaf = grph_autoload._get_parallel_canvas_node(get_parent()).get_node(old_name)
	canvas_leaf.name = name
	grph_autoload._get_parallel_canvas_node(label).text = name
	old_name = name


func _hide():
	leaf = get_child(0, true)
	remove_child(leaf)
	
	add_child(leaf, false, INTERNAL_MODE_FRONT)
	

func _exit_tree():
	leaf.owner = get_parent() 


func on_changes_applied():
	leaf.owner = get_parent() 
	_hide.call_deferred()
