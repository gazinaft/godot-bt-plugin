extends SensorLogic

var aggressive_fish: Dictionary

#Use BlackBoard to write relevant information for the AI
func _init(blackboard: BlackBoard, a):
	bb = blackboard
	actor = a


func _process(delta)->void:
	var area = actor.get_node("Animation") as Area2D
	for a in area.get_overlapping_areas():
		var fish = a.get_parent()
		if fish.is_attacking:
			aggressive_fish[fish.name] = true

	for a in aggressive_fish.keys():
		print("attacked:", a)
		bb.set_entry(a, true)
