extends Node2D
class_name Attack

enum AttackState
{
	OFF,
	WINDUP,
	ACTION,
	RECOVER
}

@export var state = AttackState.OFF

@export var character_animations : AnimationPlayer

@export var attack_move_force : float = 1
@export var attack_deceleration: float = 2

var current_force : float = 0

@onready var windup_timer = $WindupTime
@onready var follow_through_timer = $FollowThroughTime

func move_character(character : CharacterBody2D, force : float):
	character.velocity = Vector2.RIGHT * force
	character.move_and_slide()

func _physics_process(delta):
	print(state, owner.global_position)
	
	if state == AttackState.ACTION:
		move_character(owner, current_force)
		current_force -= attack_deceleration * delta
		
		if current_force < 0:
			current_force = 0

# start the attack by entering into the wind-up animation.
func start_attack():
	if state != AttackState.OFF: return
	
	character_animations.play("char_attack_windup")
	windup_timer.start();
	state = AttackState.WINDUP

# perform the attack action once the wind-up is complete.
func _on_windup_time_timeout():
	character_animations.play("char_attack_action")
	follow_through_timer.start()
	state = AttackState.ACTION
	current_force = attack_move_force

# recover from the attack action once the follow-through is complete.
func _on_follow_through_time_timeout():
	character_animations.play("char_attack_recover")
	state = AttackState.RECOVER
	current_force = 0
