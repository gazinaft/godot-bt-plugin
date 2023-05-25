@tool
class_name GridSpace
extends Control

var is_save_required: bool = false
var grph_autoload: GraphAutoload


func _ready():
	grph_autoload = get_node(GraphAutoload.PATH)


func get_connection(leaf: BaseLeaf):
	for i in range(get_child_count()):
		var child = get_child(i)
		if not child is NodeConnection:
			continue

		var conn = child as NodeConnection
		if conn.parent_base == conn.get_path() or conn.child_base == conn.get_path():
			return conn
 
