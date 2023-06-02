# meta-name: Leaf Logic
# meta-default: true
# meta-space-indent: 4
extends LeafLogic


#Runs once when this leaf is chosen to run.
func _ready()->void:
	#Set var "_is_complete" to "true" in order to finish execution manually.
	_is_complete = false
	pass

#Runs every frame.
func _process(delta)->void:
	pass
