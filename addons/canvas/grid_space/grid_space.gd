@tool
class_name GridSpace
extends Control

var is_save_required: bool = false


func _ready():
	var connection_manager: ConnectionManagerAutoload = get_node(ConnectionManagerAutoload.PATH)
	connection_manager.grid = self
	print("GridSpace child  connected")


func _process(delta):
	if is_save_required:
		save_space()
		is_save_required = false


func save_space():
	print("SAVING")
	var pack = PackedScene.new()
	pack.pack(self)
	ResourceSaver.save(pack, self.scene_file_path)
	#get_node(GraphAutoload.PATH)._editor_interface.save_scene()