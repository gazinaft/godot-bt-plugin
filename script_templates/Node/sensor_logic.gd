# meta-name: Sensor
# meta-default: true
# meta-space-indent: 4
extends SensorLogic

#Use BlackBoard to write relevant information for the AI
func _init(blackboard: BlackBoard):
    bb = blackboard


func _process(delta)->void:
    pass
    