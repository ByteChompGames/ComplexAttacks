extends Node
class_name Health

var current_health : int = 0
var max_health : int = 100

# reset health back to starting values
func reset():
	current_health = max_health;

# reduce current health by given value
func receive_damage(amount : int):
	current_health -= amount

# increase current health by given value
func heal(amount : int):
	current_health += amount
	
	if current_health >= max_health: # do not heal past max health value
		reset()
