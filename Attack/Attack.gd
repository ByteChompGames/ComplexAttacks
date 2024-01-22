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

func _process(delta):
	if state == AttackState.OFF:
		if character_animations.current_animation != "char_idle":
			character_animations.play("char_idle")

func _physics_process(delta):
	if state == AttackState.ACTION:
		owner.move_character(owner, Vector2.RIGHT, current_force)
		current_force -= attack_deceleration * delta
		
		if current_force < 0:
			current_force = 0

# start the attack by entering into the wind-up animation.
func start_attack():
	if state != AttackState.OFF: return
	character_animations.play("char_attack_windup")
	windup_timer.start();
	state = AttackState.WINDUP
	owner.set_state(2)

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

func end_attack():
	owner.set_state(0)
	state = AttackState.OFF
