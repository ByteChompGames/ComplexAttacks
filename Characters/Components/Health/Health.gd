extends Node
class_name Health

@export var max_health : int = 6
@export var health_bar : HealthBar
@export var death_particle : PackedScene

var current_health : int = 0

@onready var death_timer = $DeathTimer

# reset health back to starting values
func reset():
	current_health = max_health;
	
	if health_bar != null:
		health_bar.set_max_hearts(max_health / 2)

# reduce current health by given value
func receive_damage(amount : int):
	current_health -= amount
	
	if health_bar != null:
		health_bar.update_hearts(current_health)
	
	if current_health <= 0:
		death_timer.start()

# increase current health by given value
func heal(amount : int):
	current_health += amount
	
	if current_health >= max_health: # do not heal past max health value
		reset()

func _on_death_timer_timeout():
	if(death_particle == null):
		if owner != null:
			owner.queue_free()
	else:
		var death_vfx = death_particle.instantiate() # instantiate particle
		get_tree().root.add_child(death_vfx) # set it as a child of the root so it can persist after freeing this object
		if owner != null:
			death_vfx.global_position = owner.global_position # set the position to this position
			owner.queue_free()
