extends Node2D
class_name CharacterAudio

@export var footstep_tracks : Array[AudioStream]
@export var hurt_tracks : Array[AudioStream]

@onready var footstep_audio = $FootstepsAudio
@onready var charge_up_audio = $ChargeUpAudio
@onready var attack_audio = $AttackAudio
@onready var hurt_audio = $HurtAudio

func play_footsteps():
	footstep_audio.stream = get_random_track(footstep_tracks)
	footstep_audio.play()

func play_charge_up():
	charge_up_audio.play()

func play_attack():
	attack_audio.play()

func play_hurt():
	hurt_audio.stream = get_random_track(hurt_tracks)
	hurt_audio.play()

#returns a random track from a given list
func get_random_track(track_list : Array[AudioStream]) -> AudioStream:
	var selected_track : AudioStream
	var track_id = randi_range(0, track_list.size() - 1)
	selected_track = track_list[track_id]
	return selected_track
