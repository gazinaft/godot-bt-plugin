extends Node2D

var scene = preload("res://demo/plankton/plankton.tscn")

@export var zone_size = 500
@export var amount_per_zone = 1
@export var zones = 20

# Called when the node enters the scene tree for the first time.
func _ready():
	var offset = Vector2.ZERO
	for x in range(zones):
		for y in range(zones):
			for j in range(amount_per_zone):
				var item = scene.instantiate()
				add_child(item)
				item.position = offset + _random_position()
				item.rotation = randf_range(0, 2*PI)
			offset.y += zone_size
		offset.y = 0
		offset.x += zone_size


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _random_position()->Vector2:
	return Vector2(randi_range(0, zone_size), randi_range(0, zone_size))