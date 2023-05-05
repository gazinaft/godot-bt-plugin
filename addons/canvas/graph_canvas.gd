@tool
class_name GraphCanvas
extends VBoxContainer

var current_space: GridSpace

func add_space(space: GridSpace):
	if current_space != null:
		$SubViewportContainer/SubViewport.remove_child(current_space)
		current_space.queue_free()
	current_space = space
	$SubViewportContainer/SubViewport.add_child(space)


func _ready():
	pass


func _process(delta):
	#get_node("/root").print_tree()
	pass