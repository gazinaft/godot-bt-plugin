@tool
class_name NamedPoint
extends Control

const LETTERS = []

@onready var draggable_node: DraggableNode = $Draggable

var place_to_follow: Callable
var is_following: bool = false

signal point_moved

@export_enum('A', 'B', 'C', 'D', 'E') var letter: String :
	set (value):
		letter = value
		if is_inside_tree():
			$Label.text = letter 

func _ready():
	$Label.text = letter

func _on_follow_point_moved():
	self.position = place_to_follow.call()
	point_moved.emit()

func _on_draggable_moved():
	point_moved.emit()
