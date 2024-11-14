extends State
class_name HurtState

var player : Player

var knockback_started : bool = false

func enter():
	player.play_character_animation("char_hurt")
	player.flash_sprites(0.5)
	
	player.invulnerable = true
	player.hit_invul_timer.start()
	
	# cancel attack
	player.attack_pool.interupt_attack()
	player.camera.apply_shake()

func exit():
	pass

func physics_update(_delta : float):
	# move character in hit direction
	player.move_character(player, -player.hit_direction, player.knockback_force)
	# face hit direction
	player.flip_direction(player.character_sprite, player.hit_direction.x)
	# reduce knockback force over time
	player.knockback_force -= player.knockback_deceleration * _delta
	# end knockback when force reached 0
	if player.knockback_force <= 0:
		player.knockback_force = 0
		Transitioned.emit(self, "idle")

func on_block_transition():
	pass

func on_hurt_transition():
	Transitioned.emit(self, "hurt")
