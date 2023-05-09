@tool
class_name GraphCanvas
extends VBoxContainer

var current_space: GridSpace

@onready var viewport = $SubViewportContainer/SubViewport
@onready var camera: Camera2D = $SubViewportContainer/SubViewport/Camera2D

func add_space(space: GridSpace):
	clear_space()

	if space == null:
		return

	current_space = space
	viewport.add_child(space)
	

func clear_space():
	for i in viewport.get_child_count():
		var child = viewport.get_child(i)
		if child is GridSpace:
			viewport.remove_child(child)

	current_space = null


func get_state()->Dictionary:
	return {"zoom": camera.zoom, "offset": camera.offset}


func set_state(state: Dictionary):
	camera.zoom = state["zoom"]
	camera.offset = state["offset"]