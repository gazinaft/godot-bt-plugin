@tool
extends Node
class_name Decorator

var scene = preload("res://addons/graph_nodes/decorator/decorator_ui.tscn")

var old_name: String
var grph_autoload: GraphAutoload
var decorator: DecoratorUi

func _ready():
    grph_autoload = get_node(GraphAutoload.PATH)
    if not renamed.is_connected(_on_renamed):
        renamed.connect(_on_renamed)
    old_name = name


func _process(delta):
    if decorator == null and grph_autoload.is_in_scene_tree(self) and grph_autoload._get_parallel_canvas_node(get_parent()):
        decorator = scene.instantiate()
        decorator.text = name
        grph_autoload._get_parallel_canvas_node(get_parent()).get_node("LeafNode/VSplitContainer/Decorators").add_child(decorator)
        await get_tree().process_frame
        decorator.get_parent().get_parent().get_parent().get_node("Draggable").moved.emit(Vector2.ZERO)


func _exit_tree():
    if decorator:
        decorator.get_parent().remove_child(decorator)
        decorator.queue_free()
        decorator = null


func _on_renamed():
    decorator.text = name
    old_name = name
