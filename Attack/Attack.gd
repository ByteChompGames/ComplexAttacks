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

# - FOR ENEMIES ONLY
@export var charge_attack : bool = false
@export var charge_amount : float = 0
#

@export var wind_up_anim_name : String = ""
@export var action_anim_name : String = ""
@export var recover_anim_name : String = ""

@export var attack_move_force : float = 1
@export var charge_force_multiplier : float = 1.5
@export var attack_deceleration: float = 2

var attack_pool : AttackPool
var character_animations : AnimationPlayer
var current_force : float = 0

@onready var windup_timer = $WindupTime
@onready var follow_through_timer = $FollowThroughTime

func initialize(pool : AttackPool, animation_player : AnimationPlayer):
	character_animations = animation_player
	attack_pool = pool

func _physics_process(delta):
	if state == AttackState.ACTION:
		owner.move_character(owner, owner.get_direction(owner.character_sprite), current_force)
		current_force -= attack_deceleration * delta
		
		if current_force < 0:
			current_force = 0
	elif state == AttackState.RECOVER:
		if attack_pool.attack_buffered:
			attack_pool.perform_attack()
			state = AttackState.OFF

# start the attack by entering into the wind-up animation.
func start_attack():
	if state != AttackState.OFF: return
	character_animations.play(wind_up_anim_name)
	windup_timer.start();
	state = AttackState.WINDUP

func release_attack():
	if state != AttackState.WINDUP: return
	
	character_animations.play(action_anim_name)
	follow_through_timer.start()
	state = AttackState.ACTION
	current_force = attack_move_force * calculate_charge()
	owner.charging = false
	windup_timer.stop()

func end_attack():
	owner.set_state(0)
	attack_pool.combo_count = 0
	state = AttackState.OFF

func charge_amount_reached() -> bool:
	var percent = get_charge_percent()
	if percent >= charge_amount:
		return true
	else: return false

func get_charge_percent() -> float:
	# get a percent value based on how much time is remaining in windup
	var charge_percent = windup_timer.time_left / windup_timer.wait_time
	# get the inverse of that percent value
	charge_percent = 1 - charge_percent
	
	return charge_percent

# returns a multiplier to be applied to attack movement and damage
func calculate_charge() -> float:
	# use max value if wind_up times out
	if windup_timer.is_stopped(): return charge_force_multiplier
	
	# apply percent value to max value
	var multiplier = charge_force_multiplier * get_charge_percent()
	# keep the multiplier in an acceptable range of movement
	multiplier = clamp(multiplier, 0.75, charge_force_multiplier)
	#return the adjusted value
	return multiplier

# perform the attack action once the wind-up is complete.
func _on_windup_time_timeout():
	character_animations.play(action_anim_name)
	follow_through_timer.start()
	state = AttackState.ACTION
	current_force = attack_move_force * calculate_charge()
	owner.flash_sprites()
	owner.charging = false

# recover from the attack action once the follow-through is complete.
func _on_follow_through_time_timeout():
	if attack_pool.attack_buffered:
		state = AttackState.OFF
		attack_pool.perform_attack()
	else:
		character_animations.play(recover_anim_name)
		state = AttackState.RECOVER
		current_force = 0
