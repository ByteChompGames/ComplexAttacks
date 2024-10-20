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
