extends State
class_name EnemyHurtState

var enemy : Enemy

func enter():
	pass

func exit():
	pass

func physics_update(_delta : float):
	enemy.move_character(enemy, -enemy.hit_direction, enemy.knockback_force)
	enemy.knockback_force -= enemy.knockback_deceleration * _delta
	enemy.flip_direction(enemy.character_sprite, enemy.hit_direction.x)
	
	if enemy.knockback_force < 0:
		enemy.knockback_force = 0
		Transitioned.emit(self, "idle")
