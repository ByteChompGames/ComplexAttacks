extends State
class_name IdleState

var player : Player

func enter():
	player.play_character_animation("char_idle")

func exit():
	pass

func physics_update(_delta : float):
	var input = player.move_input()
	
	if input != 0:
		Transitioned.emit(self, "move")

func _input(event):
	if event.is_action_pressed("attack"):
		on_attack_transition()
	if event.is_action_pressed("block"):
		on_block_transition()

func on_hurt_transition():
	Transitioned.emit(self, "hurt")
