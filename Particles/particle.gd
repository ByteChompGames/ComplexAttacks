extends GPUParticles2D
class_name Particle

@export var play_on_ready : bool = false
@export var destroy_after_emission : bool = false

func _ready():
	if(play_on_ready):
		play_particle()

func play_particle():
	emitting = true

func _on_finished():
	if(destroy_after_emission):
		queue_free()
