@tool
class_name GridSpace
extends Control

var is_save_required: bool = false
var grph_autoload: GraphAutoload


func _ready():
	grph_autoload = get_node(GraphAutoload.PATH)
	

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


# func _on_node_added(node):
# 	if node is NodeConnection or not grph_autoload.is_in_scene_tree(self):
# 		return

# 	grph_autoload._get_parallel_canvas_node(node.get_parent()).add_child(node.duplicate())


# func _on_node_removed(node):
# 	var dd = grph_autoload._get_parallel_canvas_node(node)
# 	dd.get_parent().remove_child(dd)
# 	dd.queue_free()


# func _on_child_entered_tree(node:Node):
# 	if node is NodeConnection or not grph_autoload.is_in_scene_tree(self):
# 		return

# 	grph_autoload.edited_space_canvas.add_child.call_deferred(node.duplicate())


# func _on_child_exiting_tree(node:Node):
# 	var dd = grph_autoload._get_parallel_canvas_node(node)
# 	if not dd:
# 		return
# 	grph_autoload.edited_space_canvas.remove_child(dd)
# 	dd.queue_free()
 