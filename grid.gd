@tool

extends Control

@export var min_grid_size = 8

var curr_grid_size = 0
var grid_steps = [[100,20], [50,10], [25, 5]]

func _ready():
	print(grid_steps)

func _draw():
	for x in range(get_viewport().size.x / grid_steps[curr_grid_size][0]+1):
		var grid_step = grid_steps[curr_grid_size][0]
		for xx in range(1, 5):
			var small_grid_step = grid_steps[curr_grid_size][1]
			draw_line(Vector2(x*grid_step+small_grid_step*xx, 0), Vector2(x*grid_step+small_grid_step*xx, get_viewport().size.y), Color.WEB_PURPLE, -1)
	for y in range(get_viewport().size.y / grid_steps[curr_grid_size][0]+1):
		var grid_step = grid_steps[curr_grid_size][0]
		for yy in range(1, 5):
			var small_grid_step = grid_steps[curr_grid_size][1]
			draw_line(Vector2(0, y*grid_step+small_grid_step*yy), Vector2(get_viewport().size.x, y*grid_step+small_grid_step*yy), Color.WEB_PURPLE, -1)
	for x in range(1, get_viewport().size.x / grid_steps[curr_grid_size][0]+2):
		var grid_step = grid_steps[curr_grid_size][0]
		draw_line(Vector2(x*grid_step, 0), Vector2(x*grid_step, get_viewport().size.y), Color.PURPLE, -2)
	for y in range(1, get_viewport().size.y / grid_steps[curr_grid_size][0]+2):
		var grid_step = grid_steps[curr_grid_size][0]
		draw_line(Vector2(0, y*grid_step), Vector2(get_viewport().size.x, y*grid_step), Color.PURPLE, -2)


func _on_camera_2d_zoom_changed(zoom: float, min_zoom:float, max_zoom:float)->void:
	var closest = (max_zoom-min_zoom)/3
	for i in range(1,4):
		if min_zoom + closest*i >= zoom:
			curr_grid_size = i - 1
			break
	
	queue_redraw()
	