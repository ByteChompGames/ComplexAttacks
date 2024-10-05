extends State
class_name AttackState

var player : Player

func enter():
	player.charging = true
	player.attack_pool.perform_attack()

func exit():
	pass

func physics_update(_delta : float):
	var input = player.move_input()
	
	if !player.charging:
		player.attack_pool.release_attack()
	else:
		player.flip_direction(player.character_sprite, input)
		return

func _input(event):
	if event.is_action_pressed("attack"):
		player.attack_pool.buffer_attack()
	
	if event.is_action_released("attack"):
		player.charging = false
