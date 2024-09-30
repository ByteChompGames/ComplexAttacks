extends Control

signal enemy_death

var time_passed : int = 0
var enemies_left : int = 0

@onready var game_time = $GameTime
@onready var enemy_count = $EnemyCount
@onready var seconds = $Seconds

func _ready():
	GlobalSignals.connect("enemy_death", Callable(self, "on_enemy_death"))

func _on_seconds_timeout():
	time_passed += 1
	game_time.text = str(time_passed)
	
	game_time.set_text(str(time_to_minutes_secs_mili(time_passed)))

func time_to_minutes_secs_mili(time : int):
	var mins = int(time) / 60
	time -= mins * 60
	var secs = int(time)
	return str("%0*d" % [2, mins]) + ":" + str("%0*d" % [2, secs])

func on_enemy_death():
	enemies_left -= 1
	set_enemy_counter()
	
	if enemies_left <= 0:
		seconds.stop()

func set_enemy_counter():
	enemy_count.text = str(enemies_left)
