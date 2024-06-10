extends Node2D
class_name World

@export var scene_camera : Camera2D

@export var player_scene : PackedScene
 
@export var enemy_scene : PackedScene
@export var min_spawn_time : float = 3
@export var max_spawn_time : float = 5

@onready var player_spawn = $PlayerSpawnPoint

@onready var left_enemy_spawn = $EnemyLeftSpawnPoint
@onready var right_enemy_spawn = $EnemyRightSpawnPoint
@onready var enemy_spawn_timer = $EnemySpawnTimer

var player : Player
var spawn_left : bool = false

func _ready():
	spawn_player(player_spawn.position)
	set_new_spawn_time()

func _process(delta):
	if player == null:
		get_tree().reload_current_scene()

func spawn_player(location : Vector2):
	player = player_scene.instantiate()
	add_child(player)
	player.position = location
	
	if scene_camera != null:
		player.camera = scene_camera

func spawn_enemy(location : Vector2):
	var new_enemy : Enemy = enemy_scene.instantiate()
	add_child(new_enemy)
	new_enemy.position = location
	new_enemy.target = player

func set_new_spawn_time():
	var new_time = randf_range(min_spawn_time, max_spawn_time)
	enemy_spawn_timer.wait_time = new_time
	enemy_spawn_timer.start()

func _on_enemy_spawn_timer_timeout():
	if spawn_left:
		spawn_enemy(left_enemy_spawn.position)
		spawn_left = false
	else:
		spawn_enemy(right_enemy_spawn.position)
		spawn_left = true
	
	set_new_spawn_time()
