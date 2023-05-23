@tool
class_name SensorUI
extends PanelContainer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_mouse_entered():
	get_node(GraphAutoload.PATH).mouse_over = self


func _on_mouse_exited():
	get_node(GraphAutoload.PATH).mouse_over = null
	
