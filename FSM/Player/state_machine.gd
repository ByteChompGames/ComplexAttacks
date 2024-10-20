extends Node

@export var player : Player
@export var initial_state : State

var current_state : State
var states : Dictionary = {}

func _ready():
	for child in get_children():
		if child is State:
			states[child.name.to_lower()] = child
			child.Transitioned.connect(on_child_transitioned)
			child.player = player
	
	if initial_state:
		initial_state.enter()
		current_state = initial_state

func _process(delta):
	if current_state:
		current_state.update(delta)

func _physics_process(delta):
	if current_state:
		current_state.physics_update(delta)

func on_child_transitioned(state, new_state_name):
	# do not accept transitions from states that are not the current
	if state != current_state:
		return
	# do not transition back into the current state
	if (new_state_name == current_state.name.to_lower()):
		return
	
	var new_state = states.get(new_state_name.to_lower())
	if !new_state:
		return
	
	if current_state:
		current_state.exit()
	
	print(owner.name, " transitioned from - ", current_state.name, " to - ", new_state.name)
	
	new_state.enter()
	current_state = new_state

func _input(event):
	if event.is_action_pressed("attack"):
		current_state.on_attack_transition()

func _on_overhead_attack_attack_end():
	current_state.on_attack_end_transition()


func _on_stab_attack_attack_end():
	current_state.on_attack_end_transition()

func _on_swing_attack_attack_end():
	current_state.on_attack_end_transition()

func _on_hurtbox_on_hurt():
	current_state.Transitioned.emit(current_state, "hurt")
