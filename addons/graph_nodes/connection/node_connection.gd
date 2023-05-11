@tool
extends Control
class_name NodeConnection

var parent: LeafNode
var child: LeafNode

@onready var line_conn: LineConnection2D = $LineConnection2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _start_connection(p: LeafNode):
	parent = p
	print("before point manipulation")
	line_conn.point_a.position = parent._get_anchor_for_children()
	line_conn.point_a.place_to_follow = parent._get_anchor_for_children

	parent.draggable_node.moved.connect(line_conn.point_a._on_follow_point_moved)
	
	line_conn.point_b.position = get_local_mouse_position()
	line_conn.point_b.draggable_node.is_being_dragged = true
	
	print("node connection start")


func _end_connection(c: LeafNode):
	if (c == parent):
		return
	line_conn.point_b.draggable_node.is_being_dragged = false

	child = c
	line_conn.point_b.position = child._get_anchor_for_parents()
	line_conn.point_b.point_moved.emit()
	line_conn.point_b.place_to_follow = child._get_anchor_for_parents
	
	child.draggable_node.moved.connect(line_conn.point_b._on_follow_point_moved)
	
	print("node connection end")
	print("parent is", parent.name)
	print("child is", child.name)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
