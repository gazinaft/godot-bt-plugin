@tool
extends Node
class_name BaseDecorator

var scene = preload("res://addons/graph_nodes/decorator/decorator.tscn")

var old_name: String
var grph_autoload: GraphAutoload
var decorator: Decorator

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


func _exit_tree():
    decorator.get_parent().remove_child(decorator)
    decorator.queue_free()
    decorator = null


func _on_renamed():
    decorator.text = name
    old_name = name
