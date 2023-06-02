extends Node2D
class_name Plankton


@export var colors: Array[Color]
@onready var sprite: Sprite2D = $Sprite2D
@onready var particles: GPUParticles2D = $GPUParticles2D

var die: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var shader = sprite.material as ShaderMaterial
	shader.set_shader_parameter("color", colors.pick_random())

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if die:
		particles.emitting = true
		sprite.hide()
		await get_tree().create_timer(particles.lifetime).timeout
		queue_free()

