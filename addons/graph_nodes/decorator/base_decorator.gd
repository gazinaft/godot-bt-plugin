@tool
extends Node
class_name BaseDecorator

var scene = preload("res://addons/graph_nodes/decorator/decorator.tscn")

var old_name: String
var grph_autoload: GraphAutoload
var decorator: Decorator

@export var decorated = false


func _ready():
    print("FUCKING READY")
    grph_autoload = get_node(GraphAutoload.PATH)
    print("CONNECT RENAMED")
    if not renamed.is_connected(_on_renamed):
        renamed.connect(_on_renamed)
    old_name = name


func _after_enter():
    grph_autoload = get_node(GraphAutoload.PATH)
    if grph_autoload.is_in_scene_tree(self):
        print("CONNECT RENAMED")
        if not renamed.is_connected(_on_renamed):
            renamed.connect(_on_renamed)
        old_name = name

func add_canvas_decorator(leaf):
    decorator = scene.instantiate()
    decorator.text = name
    leaf.get_node("LeafNode/VSplitContainer/Decorators").add_child(decorator)


func _on_renamed():
    decorator.text = name
    var canvas_dec = grph_autoload._get_parallel_canvas_node(get_parent()).get_node(old_name)
    canvas_dec.name = name
    old_name = name
