@tool
class_name GridSpace
extends Control

var is_save_required: bool = false


func _process(delta):
	if is_save_required:
		save_space()
		is_save_required = false


func get_connection(leaf: BaseLeaf):
	for i in range(get_child_count()):
		var child = get_child(i)
		if not child is NodeConnection:
			continue

		var conn = child as NodeConnection
		if conn.parent_base == conn.get_path() or conn.child_base == conn.get_path():
			return conn


func save_space():
	print("SAVING")
	var pack = PackedScene.new()
	pack.pack(self)
	ResourceSaver.save(pack, self.scene_file_path)
	#get_node(GraphAutoload.PATH)._editor_interface.save_scene()



func _on_child_entered_tree(node:Node):
	var grph_autoload = get_node(GraphAutoload.PATH)
	if node is NodeConnection or not grph_autoload.is_in_scene_tree(self):
		return

	grph_autoload.edited_space_canvas.add_child(node.duplicate())


func _on_child_exiting_tree(node:Node):
	var grph_autoload = get_node(GraphAutoload.PATH)

	var dd = grph_autoload._get_parallel_canvas_node(node)
	grph_autoload.edited_space_canvas.remove_child(grph_autoload._get_parallel_canvas_node(node))
 