extends Node2D
class_name Attack

@export var character_animations : AnimationPlayer

var attack_started = false

@onready var windup_timer = $WindupTime
@onready var follow_through_timer = $FollowThroughTime

func start_attack():
	if attack_started: return
	
	character_animations.play("char_attack_windup")
	windup_timer.start();
	attack_started = true


func _on_windup_time_timeout():
	character_animations.play("char_attack_action")
	follow_through_timer.start()


func _on_follow_through_time_timeout():
	character_animations.play("char_attack_recover")
	attack_started = false
