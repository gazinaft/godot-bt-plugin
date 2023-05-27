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

signal apply_changes

var opened_scenes: Dictionary = {}

func _process(delta):
    if _graph_canvas != null and edited_space_canvas == null:
        edited_space_canvas = GridSpace.new()
        _graph_canvas.add_space(edited_space_canvas)

func edit_space(space: GridSpace):
    if space == null:
        return
    
    edited_space_tree = space

    print("EDITED SPACE: ", edited_space_tree)
    print("EDITED CANVAS: ", edited_space_canvas)


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
    # if node == null:
    #     return null
    # #print("_get_parallel_tree_node: ", node.get_path().get_concatenated_names())
    # var result = regex.search(node.get_path().get_concatenated_names())

    # if not result:
    #     return null
    if edited_space_tree == null or edited_space_tree.get_parent() == null:
        return  null

    var result = _get_space_path(node)

    return edited_space_tree.get_parent().get_node_or_null(result)




func _get_parallel_canvas_node(node)->Node:
    # #print("_get_parallel_canvas_node: ", node.get_path().get_concatenated_names())
    # var result = regex_canvas.search(node.get_path().get_concatenated_names())

    # if not result or not edited_space_canvas:
    #     return null
    var result = _get_space_path(node)

    return edited_space_canvas.get_parent().get_node_or_null(result)


func _get_space_path(n)->String:
    if n is GridSpace:
        return n.name
    if n.get_parent() == null:
        print(n.get_path())
        return ""
    return _get_space_path(n.get_parent()) + "/" + n.name

func is_in_scene_tree(node):
    var result = _get_parallel_tree_node(node)
    return result != null


func is_in_canvas_tree(node):
    var result = _get_parallel_canvas_node(node)
    return result != null


func remove_from_cache(path):
    print(path)
    if opened_scenes.has(path):
        print("REMOVED: ", path)
        opened_scenes.erase(path)
