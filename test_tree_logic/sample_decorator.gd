extends DecoratorLogic

#Use BlackBoard to make decisions based on relevant information for the AI
func _init(blackboard: BlackBoard):
	bb = blackboard

#Return whether the AI should chose this branch to chose a strategy
func can_pass()->bool:
	return true

