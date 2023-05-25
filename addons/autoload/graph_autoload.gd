@tool
class_name GraphAutoload
extends Node

const NAME = "GrphAutoload"
const PATH = "/root/" + NAME

var _editor_interface: EditorInterface
var _graph_canvas: GraphCanvas

var edited_space_tree: GridSpace
var edited_space_canvas: GridSpace

var mouse_over: Control

var regex: RegEx
var regex_canvas: RegEx

signal apply_changes

var opened_scenes: Dictionary = {}

func _ready():
    regex = RegEx.new()
    regex.compile("(?<=SubViewport/).*")
    regex_canvas = RegEx.new()
    regex_canvas.compile("(?<=SubViewport@\\d{4}/).*")


func edit_space(space: GridSpace):
    if space != null and space == edited_space_tree:
        return 

    if space == null:
        edited_space_tree = null
        _graph_canvas.clear_space()
        return

    edited_space_canvas = GridSpace.new()
    edited_space_canvas.name = space.name
    
    edited_space_tree = space

    print("EDITED SPACE: ", edited_space_tree)
    print("EDITED CANVAS: ", edited_space_canvas)

    _graph_canvas.add_space(edited_space_canvas)


func sync_changes(node: Node, changes: Callable):
    var tree = _get_parallel_tree_node(node)
    changes.call(node)
    if tree == null:
        return
    changes.call(tree)


func select_in_tree(node):
    _editor_interface.get_selection().clear()
    _editor_interface.get_selection().add_node(_get_parallel_tree_node(node))


func _get_parallel_tree_node(node)->Node:
    if node == null:
        return null
    #print("_get_parallel_tree_node: ", node.get_path().get_concatenated_names())
    var result = regex.search(node.get_path().get_concatenated_names())

    if not result:
        return null


    var n = edited_space_tree.get_parent().get_node_or_null(result.get_string())

    return n


func _get_parallel_canvas_node(node)->Node:
    #print("_get_parallel_canvas_node: ", node.get_path().get_concatenated_names())
    var result = regex_canvas.search(node.get_path().get_concatenated_names())

    if not result or not edited_space_canvas:
        return null
        
    return edited_space_canvas.get_parent().get_node_or_null(result.get_string())


func is_in_scene_tree(node):
    var result = regex_canvas.search(node.get_path().get_concatenated_names())
    return result != null


func is_in_canvas_tree(node):
    var result = regex.search(node.get_path().get_concatenated_names())
    return result != null


func remove_from_cache(path):
    print(path)
    if opened_scenes.has(path):
        print("REMOVED: ", path)
        opened_scenes.erase(path)
