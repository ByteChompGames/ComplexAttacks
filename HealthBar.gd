extends Node2D
class_name HealthBar

@onready var heart_one = $Heart_One
@onready var heart_two = $Heart_Two
@onready var heart_three = $Heart_Three
@onready var active_timer = $ActiveTimer

func set_health_bar(health_ratio : float):
	visible = true
	active_timer.start()
	
	# full health
	if health_ratio == 1:
		fill_bar()
	elif health_ratio == 0:
		empty_bar();
	elif health_ratio < 1 and health_ratio >= 0.8:
		set_heart_anim(1, "full")
		set_heart_anim(2, "full")
		set_heart_anim(3, "half")
	elif health_ratio < 0.8 and health_ratio >= 0.6:
		set_heart_anim(1, "full")
		set_heart_anim(2, "full")
		set_heart_anim(3, "empty")
	elif health_ratio < 0.6 and health_ratio >= 0.4:
		set_heart_anim(1, "full")
		set_heart_anim(2, "half")
		set_heart_anim(3, "empty")
	elif health_ratio < 0.4 and health_ratio >= 0.2:
		set_heart_anim(1, "full")
		set_heart_anim(2, "empty")
		set_heart_anim(3, "empty")
	elif health_ratio < 0.2 and health_ratio > 0:
		set_heart_anim(1, "half")
		set_heart_anim(2, "empty")
		set_heart_anim(3, "empty")

func fill_bar():
	set_heart_anim(1, "full")
	set_heart_anim(2, "full")
	set_heart_anim(3, "full")

func empty_bar():
	set_heart_anim(1, "empty")
	set_heart_anim(2, "empty")
	set_heart_anim(3, "empty")

func set_heart_anim(id :int, anim_name : String):
	match(id):
		1:
			heart_one.play(anim_name)
		2:
			heart_two.play(anim_name)
		3:
			heart_three.play(anim_name)


func _on_active_timer_timeout():
	visible = false
