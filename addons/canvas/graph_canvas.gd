@tool
class_name GraphCanvas
extends VBoxContainer

var current_space: GridSpace
var editor_interface: EditorInterface

@onready var viewport = $SubViewportContainer/SubViewport
@onready var camera: Camera2D = $SubViewportContainer/SubViewport/Camera2D

func add_space(space: GridSpace):
	print("ADD SPACE: ", current_space, space)
	clear_space()

	if space == null:
		return

	current_space = space
	viewport.add_child(space)
	

func clear_space():
	print("CLEAR SPACE: ", current_space)
	if current_space == null:
		return
	viewport.remove_child(current_space)
	current_space.queue_free()
	current_space = null


func get_state()->Dictionary:
	return {"zoom": camera.zoom, "offset": camera.offset}


func set_state(state: Dictionary):
	camera.zoom = state["zoom"]
	camera.offset = state["offset"]
