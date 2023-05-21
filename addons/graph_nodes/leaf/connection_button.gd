@tool
extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_down():
	print(get_node(ConnectionManagerAutoload.PATH))
	get_node(ConnectionManagerAutoload.PATH).connection_started(get_parent().get_parent().get_parent())


func _on_button_up():
	get_node(ConnectionManagerAutoload.PATH).connection_ended()
