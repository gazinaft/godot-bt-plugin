extends LeafLogic

var i: int

#Runs once when this leaf is chosen to run.
func _ready()->void:
	i = 0	
	_is_complete = false
	print("Start leaf logic")

#Runs every frame.
func _process(delta)->void:
	i += 1;
	if i == 20:
		_is_complete = true
		print("End leaf logic")
