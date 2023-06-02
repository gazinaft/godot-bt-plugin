@tool
extends Node
class_name Decorator

var scene = preload("res://addons/graph_nodes/decorator/decorator_ui.tscn")

var old_name: String
var grph_autoload: GraphAutoload
var decorator: DecoratorUi
@export_file("*.gd") var decorator_logic


func _ready():
    if not Engine.is_editor_hint():
        set_process(false)
        set_process_input(false)
        return
    grph_autoload = get_node(GraphAutoload.PATH)

    if not renamed.is_connected(_on_renamed):
        renamed.connect(_on_renamed)
    old_name = name


func _process(delta):
    if decorator == null and grph_autoload.is_in_scene_tree(self) and grph_autoload._get_parallel_canvas_node(get_parent()):
        if  grph_autoload._get_parallel_canvas_node(get_parent()).get_node("LeafNode/VSplitContainer/Decorators").has_node(NodePath(name)):
            return
        decorator = scene.instantiate()
        decorator.name = name
        decorator.text = name
        grph_autoload._get_parallel_canvas_node(get_parent()).get_node("LeafNode/VSplitContainer/Decorators").add_child(decorator)
        decorator.get_parent().get_parent().get_parent().get_node("Draggable").moved.emit(Vector2.ZERO)


func _exit_tree():
    if not Engine.is_editor_hint():
        return
    if decorator:
        decorator.get_parent().remove_child.call_deferred(decorator)
        decorator.queue_free()
        decorator = null


func _on_renamed():
    decorator.text = name
    old_name = name

func get_class():
    return "Decorator"

func is_class(clas: String):
    return clas == "Decorator"