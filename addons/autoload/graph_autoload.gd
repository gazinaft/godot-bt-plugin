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

func _ready():
    regex = RegEx.new()
    regex.compile("(?<=SubViewport/).*")


func edit_space(space: GridSpace, space_duplicate):
    edited_space_tree = space
    edited_space_canvas = space_duplicate
    _graph_canvas.add_space(edited_space_canvas)


func sync_changes(node: Node, changes: Callable):
    var tree = _get_parallel_tree_node(node)
    changes.call(node)
    changes.call(tree)


func select_in_tree(node):
    _editor_interface.get_selection().clear()
    _editor_interface.get_selection().add_node(_get_parallel_tree_node(node))


func _get_parallel_tree_node(node)->Node:
    var result = regex.search(node.get_path().get_concatenated_names())

    return edited_space_tree.get_parent().get_node(result.get_string())
