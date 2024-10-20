extends State
class_name MoveState

var player : Player

func enter():
	player.play_character_animation("char_run")

func exit():
	pass

func physics_update(_delta : float):
	var input = player.move_input()
	
	var move_direction = Vector2.RIGHT * input
	player.move_character(player, move_direction, player.move_speed)
	player.flip_direction(player.character_sprite, input);
	
	if input == 0:
		Transitioned.emit(self, "idle")
