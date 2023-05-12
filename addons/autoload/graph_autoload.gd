@tool
class_name GraphAutoload
extends Node

const NAME = "GrphAutoload"
const PATH = "/root/" + NAME

var _editor_interface: EditorInterface
var _graph_canvas: GraphCanvas

var edited_space_tree: GridSpace
var edited_space_canvas: GridSpace

var regex: RegEx

signal apply_changes

var opened_scenes: Dictionary = {}

func _ready():
    regex = RegEx.new()
    regex.compile("(?<=SubViewport/).*")


func edit_space(space: GridSpace):
    if space != null and space == edited_space_tree:
        return 

    if space == null:
        edited_space_tree = null
        _graph_canvas.clear_space()
        return

    if not opened_scenes.has(space.scene_file_path):
        opened_scenes[space.scene_file_path] = space.duplicate()

    edited_space_tree = space
    edited_space_canvas = opened_scenes[space.scene_file_path]

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
    var result = regex.search(node.get_path().get_concatenated_names())

    return edited_space_tree.get_parent().get_node_or_null(result.get_string())

func remove_from_cache(path):
    if opened_scenes.has(path):
        opened_scenes.erase(path)
