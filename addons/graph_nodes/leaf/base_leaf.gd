@tool
class_name Leaf
extends Control

var scene = preload("res://addons/graph_nodes/leaf/leaf_node.tscn")

var leaf: PanelContainer
var grph_autoload: GraphAutoload
var old_name: String
@export_file("*.gd") var leaf_logic


func _ready():
	grph_autoload = get_node(GraphAutoload.PATH)

	old_name = name

	if grph_autoload.is_in_scene_tree(self):
		if not renamed.is_connected(_on_renamed):
			renamed.connect(_on_renamed)
	if grph_autoload.is_in_canvas_tree(self):
		var b_leaf = grph_autoload._get_parallel_tree_node(self)
		leaf = scene.instantiate()
		position = Vector2.ZERO
		leaf.get_node("VSplitContainer/Label").text = name
		leaf.position = b_leaf.position
		add_child(leaf)
		
	request_ready()


func _process(delta):
	if grph_autoload.is_in_scene_tree(self) and not grph_autoload._get_parallel_canvas_node(self):
		grph_autoload._get_parallel_canvas_node(get_parent()).add_child(self.duplicate())


func _on_renamed():
	var canvas_leaf = grph_autoload._get_parallel_canvas_node(get_parent()).get_node(old_name)
	canvas_leaf.name = name
	canvas_leaf.get_node("LeafNode/VSplitContainer/Label").text = name
	old_name = name


func _exit_tree():
	if grph_autoload.is_in_scene_tree(self):
		var bl = grph_autoload._get_parallel_canvas_node(self)
		bl.get_parent().remove_child.call_deferred(bl)
		bl.queue_free()
