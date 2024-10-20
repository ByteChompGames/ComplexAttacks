extends State
class_name HurtState

var player : Player

func enter():
	pass

func exit():
	pass

func physics_update(_delta : float):
	player.move_character(player, -player.hit_direction, player.knockback_force)
	player.knockback_force -= player.knockback_deceleration * _delta
	player.flip_direction(player.character_sprite, player.hit_direction.x)
	
	if player.knockback_force < 0:
		player.knockback_force = 0
		Transitioned.emit(self, "idle")
