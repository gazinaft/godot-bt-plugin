extends Control
class_name ConnectionManager

var start_point: LeafNode :
	set(value):
		end_point = null
		start_point = value

var end_point: LeafNode :
	set(value):
		if start_point == null:
			return
		if start_point == value:
			start_point = null
			return
		end_point = value
		_create(start_point, end_point)

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# func _set_start(start: LeafNode):
# 	end_point = null
# 	start_point = start

# func _set_end(end: LeafNode):
# 	if start_point == null:
# 		return
# 	if start_point == end:
# 		start_point = null
# 		return
# 	end_point = end
# 	_create(start_point, end_point)

func _create(start: LeafNode, end: LeafNode):
	var conn = NodeConnection.new()
	conn._connect_nodes(start, end)
	get_parent().add_child(conn)


func _unhandled_input(event):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and not event.pressed:
			start_point = null

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
