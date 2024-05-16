extends Node2D
class_name HealthBar

@onready var heart_gui_class = preload("res://Characters/Components/Health/heart_gui.tscn")

@onready var heart_container = $HeartContainer
@onready var active_timer = $ActiveTimer


func set_max_hearts(max : int):
	for i in range(max):
		var heart = heart_gui_class.instantiate()
		heart_container.add_child(heart)

func update_hearts(current_health : int):
	visible = true
	active_timer.start()
	
	var hearts = heart_container.get_children()
	var current_heart : int = 0
	var half_count : int = 2
	
	# empty health bar
	for i in range(hearts.size()):
		hearts[i].update_heart(2)
	
	# fill bar back up based on current health
	for i in range(current_health):
		# update heart state based on half count
		half_count -= 1
		hearts[current_heart].update_heart(half_count)
		# when fill count = 0, move onto next heart
		if half_count == 0:
			current_heart += 1
			half_count = 2

func _on_active_timer_timeout():
	visible = false
