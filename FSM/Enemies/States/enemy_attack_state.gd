extends State
class_name EnemyAttackState

var enemy : Enemy

func enter():
	enemy.attack_pool.perform_attack()

func exit():
	pass
