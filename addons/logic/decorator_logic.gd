extends Node
class_name DecoratorLogic

var bb: BlackBoard


func _init(blackboard: BlackBoard):
    bb = blackboard


func can_pass()->bool:
    return true