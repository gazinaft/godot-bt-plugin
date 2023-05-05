@tool
class_name BaseLeaf
extends Control

var scene = preload("res://addons/graph_nodes/leaf/base_leaf.tscn")

var leaf: Node

func _ready():
	if get_child_count() == 0:
		print("ADDING")
		leaf = scene.instantiate()
		add_child(leaf, false, INTERNAL_MODE_BACK)
		registed_leaf.call_deferred()


func registed_leaf():
	print("REGISTERING")
	leaf.owner = get_parent()
	get_parent().is_save_required = true