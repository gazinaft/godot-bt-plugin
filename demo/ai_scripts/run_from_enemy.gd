extends LeafLogic

func _init(blackboard: BlackBoard, a):
	bb = blackboard
	actor = a

#Runs once when this leaf is chosen to run.
func _ready()->void:
	#Set var "_is_complete" to "true" in order to finish execution manually.
	_is_complete = false
	actor.is_running = true

#Runs every frame.
func _process(delta)->void:
	var enemies = []
	var in_range = bb.get_entry("fish_in_range")
	for f in in_range:
		if bb.get_entry(f):
			enemies.append(actor.get_parent().get_node(f))
	
	actor.get_node("Direction").run_from_enemies(enemies, delta)

