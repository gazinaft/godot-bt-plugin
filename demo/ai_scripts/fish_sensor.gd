extends SensorLogic

var close_fish: Dictionary

func _init(blackboard: BlackBoard, a):
    bb = blackboard
    actor = a
    var s = actor.get_node("FishSensor") as Area2D
    s.area_entered.connect(_on_area_entered)
    s.area_exited.connect(_on_area_exited)


func _process(delta):
    var only_in_range = []
    for k in close_fish.keys():
        if close_fish[k]:
            only_in_range.append(k)
    if len(only_in_range) > 0:
        bb.set_entry("fish_in_range", only_in_range)
    else:
        bb.set_entry("fish_in_range", null)


func _on_area_entered(area):
    if area.get_parent() is FishPlayer:
        close_fish[area.get_parent().name] = true


func _on_area_exited(area):
    if area.get_parent() is FishPlayer:
        close_fish[area.get_parent().name] = false

