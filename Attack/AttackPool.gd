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

func buffer_attack():
	if !attack_buffer.is_stopped():
		attack_buffer.stop()
	
	attack_buffer.start()
	attack_buffered = true

# if charging the current attack, release the attack
func release_attack():
	var attack_id = combo_count -1
	if attack_id < 0:
		attack_id = combo_order.size() - 1
	
	var current_attack = combo_order[attack_id]
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
	var attack = get_attack()
	attack.start_attack()
	# update the combo count and reset the combo timer
	update_combo()
	if !combo_timer.is_stopped():
		combo_timer.stop()
	combo_timer.start()

# returns the attack at the current combo from the order of attacks
func get_attack() -> Attack:
	var selected_attack = combo_order[combo_count]
	return selected_attack

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
