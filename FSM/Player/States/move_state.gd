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

func _input(event):
	if event.is_action_pressed("attack"):
		on_attack_transition()
	if event.is_action_pressed("block"):
		on_block_transition()

func on_hurt_transition():
	Transitioned.emit(self, "hurt")
