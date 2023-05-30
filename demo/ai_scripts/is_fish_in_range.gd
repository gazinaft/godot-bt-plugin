extends DecoratorLogic

#Use BlackBoard to make decisions based on relevant information for the AI
func _init(blackboard: BlackBoard):
	bb = blackboard

#Return whether the AI should chose this branch to chose a strategy
func can_pass()->bool:
	var in_range = bb.get_entry("fish_in_range")
	print("fish_in_range: ", in_range)
	if in_range:
		return true
	
	return false

