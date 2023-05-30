extends DecoratorLogic

#Use BlackBoard to make decisions based on relevant information for the AI
func _init(blackboard: BlackBoard):
	bb = blackboard

#Return whether the AI should chose this branch to chose a strategy
func can_pass()->bool:
	var in_range = bb.get_entry("fish_in_range")
	print("in_range_in_dec: ", in_range)
	for f in in_range:
		print("aggressive_fish: ", bb.get_entry(f))
		if bb.get_entry(f):
			return true

	return false

