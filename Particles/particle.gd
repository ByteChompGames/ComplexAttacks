extends GPUParticles2D
class_name Particle

@export var play_on_ready : bool = false
@export var destroy_after_emission : bool = false
@export var particle_tracks : Array[AudioStream]

@onready var particle_audio = $ParticleAudio

func _ready():
	if(play_on_ready):
		play_particle()

func play_particle():
	emitting = true
	play_particle_audio()

func _on_finished():
	if(destroy_after_emission):
		queue_free()

func play_particle_audio():
	var selected_track : AudioStream
	var track_id = randi_range(0, particle_tracks.size() - 1)
	selected_track = particle_tracks[track_id]
	particle_audio.stream = selected_track
	particle_audio.play()

