extends Node
class_name BlackBoard

var entries: Dictionary = {}


func set_entry(id: String, data)->void:
    entries[id] = data


func get_entry(id: String):
    if not entries.has(id):
        return null

    return entries[id]