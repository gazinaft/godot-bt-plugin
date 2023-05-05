@tool
extends Node


func _on_gui_input(event:InputEvent):
    pass
    if event is InputEventMouseButton:
        var mouse = event as InputEventMouseButton
        if mouse.button_index != MOUSE_BUTTON_MASK_LEFT:
            return
        get_node(GraphAutoload.PATH).select_in_tree(get_parent())
