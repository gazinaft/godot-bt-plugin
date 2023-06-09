@tool
class_name LeafNode
extends PanelContainer

@onready var draggable_node: DraggableNode = $Draggable

func _get_anchor_for_children():
	return position + Vector2(size.x/2 - 15, size.y-17)

func _get_anchor_for_parents():
	return position + Vector2(size.x/2-15, -13)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	get_node(GraphAutoload.PATH).mouse_over = self


func _on_mouse_exited():
	get_node(GraphAutoload.PATH).mouse_over = null
