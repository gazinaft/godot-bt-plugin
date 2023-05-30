extends LeafLogic

var direction_interval = 5
var time_passed = 0

func _init(blackboard: BlackBoard, a):
	bb = blackboard
	actor = a


func _ready()->void:
	_is_complete = false
	actor.is_running = false
	

func _process(delta)->void:
	time_passed += delta
	if time_passed > direction_interval:
		time_passed = 0
		actor.get_node("Direction").peacefull_direction(delta)

	