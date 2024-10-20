extends State
class_name EnemyMoveState

var enemy : Enemy

func enter():
	enemy.play_character_animation("char_run")

func exit():
	pass

func physics_update(_delta : float):
	# move the enemy towards the target
	var move_direction = enemy.target.global_position - enemy.global_position
	enemy.move_character(enemy, move_direction.normalized(), enemy.move_speed)
	enemy.flip_direction(enemy.character_sprite, move_direction.normalized().x)
	#attack if in range
	if abs(move_direction.x) < enemy.attack_range:
		on_attack_transition()
