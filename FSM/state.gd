extends Node
class_name State

signal Transitioned

func enter():
	pass

func exit():
	pass

func update(_delta : float):
	pass

func physics_update(_delata : float):
	pass

# Transitions

func on_attack_transition():
	Transitioned.emit(self, "attack")

func on_attack_end_transition():
	Transitioned.emit(self, "idle")

func on_target_null_transition():
	pass
