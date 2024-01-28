extends Node2D
class_name AttackPool

@export var character_animations : AnimationPlayer

@export var combo_order : Array[Attack]

var combo_count : int = 0
var attack_buffered : bool = false

@onready var combo_timer = $ComboTimer
@onready var attack_buffer = $AttackBuffer

func _ready():
	# if no combo order for attacks is provided, build one from the order the attacks are listed in the children of this node.
	if combo_order.size() == 0:
		for child in get_children():
			if child.has_method("initialize"):
				combo_order.append(child)
	
	# initialize the attacks
	for attack in combo_order:
		attack.initialize(self, character_animations)

# Get Attack Methods
# - returns the attack currently being performed
func get_current_attack() -> Attack:
	var attack_id = combo_count -1
	if attack_id < 0:
		attack_id = combo_order.size() - 1
	
	return combo_order[attack_id]
	
# - returns the next attack that will be performed
func get_next_attack() -> Attack:
	return combo_order[combo_count]

# - returns the attack that matches the given id
func get_attack_from_list(id : int) -> Attack:
	return combo_order[id]

func buffer_attack():
	if !attack_buffer.is_stopped():
		attack_buffer.stop()
	
	attack_buffer.start()
	attack_buffered = true

# - returns whether the current attack is a charge attack
func current_attack_charging() -> bool:
	var attack = get_current_attack()
	
	return attack.charge_attack

# if charging the current attack, release the attack
func release_attack():
	var current_attack = get_current_attack()
	current_attack.release_attack()

func perform_attack():
	# put the character in the attack state
	owner.set_state(2)
	
	# if the attack was buffered, reset the buffer
	if attack_buffered:
		attack_buffered = false
		if !attack_buffer.is_stopped():
			attack_buffer.stop()
	
	# start the next attack in the combo
	var attack = get_next_attack()
	attack.start_attack()
	# update the combo count and reset the combo timer
	update_combo()
	if !combo_timer.is_stopped():
		combo_timer.stop()
	combo_timer.start()

func interupt_attack():
	var current_attack = get_current_attack()
	if current_attack.state == Attack.AttackState.WINDUP:
		current_attack.windup_timer.stop()
	if current_attack.state == Attack.AttackState.ACTION:
		current_attack.follow_through_timer.stop()
	
	current_attack.end_attack()

# move to the next attack in the combo, reset if the final attack is reached
func update_combo():
	combo_count += 1
	if combo_count >= combo_order.size():
		combo_count = 0

# reset the combo
func _on_combo_timer_timeout():
	combo_count = 0

# use the buffered attack
func _on_attack_buffer_timeout():
	attack_buffered = false
