@tool
class_name GridSpace
extends Control

var is_save_required: bool = false

func _ready():
	print("SPACE READY")


func _process(delta):
	if is_save_required:
		save_space()
		is_save_required = false


func save_space():
	var pack = PackedScene.new()
	pack.pack(self)
	ResourceSaver.save(pack, get_tree().edited_scene_root.scene_file_path)
	#get_node(GraphAutoload.PATH)._editor_interface.save_scene()