extends State
class_name BlockState

var player : Player

func enter():
	player.play_character_animation("char_block")
	player.in_block = true
	player.in_parry = true
	player.parry_timer.start()
	player.flash_sprites(0.5)
	player.knockback_force = 0

func physics_update(_delta : float):
	if player.knockback_force > 0:
		player.move_character(player, -player.hit_direction, player.knockback_force)
		player.knockback_force -= player.knockback_deceleration * _delta
	elif player.knockback_force < 0:
		player.knockback_force = 0

func _input(event):
	if event.is_action_pressed("attack"):
		on_attack_transition()
	if event.is_action_released("block"):
		Transitioned.emit(self, "idle")

func on_attack_end_transition():
	pass

func on_hurt_transition():
	Transitioned.emit(self, "hurt")
