@tool
class_name GridSpace
extends Control

var is_save_required: bool = false
var grph_autoload: GraphAutoload


func _ready():
	grph_autoload = get_node(GraphAutoload.PATH)
	
	if grph_autoload.is_in_scene_tree(self):
		if not renamed.is_connected(_on_renamed):
			renamed.connect(_on_renamed)


func _on_renamed():
	grph_autoload.edited_space_canvas.name = name
 
