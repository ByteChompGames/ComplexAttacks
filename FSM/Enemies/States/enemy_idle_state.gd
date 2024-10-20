extends State
class_name EnemyIdleState

var enemy : Enemy

func enter():
	enemy.play_character_animation("char_idle")

func exit():
	pass

func physics_update(_delta : float):
	if enemy.target != null:
		enemy.has_target = true
		Transitioned.emit(self, "move")

