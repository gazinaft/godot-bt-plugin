extends Control
class_name NodeConnection

var parent: LeafNode
var child: LeafNode

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _connect_nodes(p: LeafNode, c: LeafNode):
	parent = p
	child = c

	$LineConnection2D/PointA.position = parent._get_anchor_for_children()
	$LineConnection2D/PointB.position = child._get_anchor_for_parents()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
