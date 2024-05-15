extends Node
class_name Health

@export var max_health : float = 100
@export var health_bar : HealthBar

var current_health : float = 0

@onready var death_timer = $DeathTimer

# reset health back to starting values
func reset():
	current_health = max_health;

# reduce current health by given value
func receive_damage(amount : int):
	current_health -= amount
	print(owner.name, " ", current_health, " health remains.")
	
	if health_bar != null:
		var health_ratio = current_health / max_health
		health_bar.set_health_bar(health_ratio)
	
	if current_health <= 0:
		death_timer.start()

# increase current health by given value
func heal(amount : int):
	current_health += amount
	
	if current_health >= max_health: # do not heal past max health value
		reset()

func _on_death_timer_timeout():
	if owner != null:
		owner.queue_free()
