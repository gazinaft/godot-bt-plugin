extends Node
class_name LeafLogic

var _is_complete: bool = false
var bb: BlackBoard
var actor

func _init(blackboard: BlackBoard, a):
    bb = blackboard
    actor = a

func _ready():
    pass


func _process(delta):
    pass