extends Node
class_name SensorLogic

var bb: BlackBoard
var actor 

func _init(blackboard: BlackBoard, a):
    bb = blackboard
    actor = a


func _process(delta):
    pass
