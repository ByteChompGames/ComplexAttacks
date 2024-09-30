extends Node2D
class_name Stage

@export_file("*.tscn") var next_scene : String

@export var scene_camera : Camera2D

@export var player_scene : PackedScene
@export var enemy_scene : PackedScene

@export var min_spawn_time : float = 3
@export var max_spawn_time : float = 5

@export var enemy_total : int = 10

var player : Player
var spawn_left : bool = false

var enemies_defeated : int = 0
var enemies_spawned : int = 0

@onready var player_spawn = $PlayerSpawnPoint

@onready var left_enemy_spawn = $EnemyLeftSpawnPoint
@onready var right_enemy_spawn = $EnemyRightSpawnPoint
@onready var enemy_spawn_timer = $EnemySpawnTimer

@onready var stage_animator = $StageAnimator
@onready var gui = $GUI
@onready var exit_stage_delay = $ExitStageDelay
@onready var exit_blocker_right = $EdgeBlockerRight/CollisionShape2D

func _ready():
	randomize()
	stage_animator.play("fade_in")
	GlobalSignals.connect("enemy_death", Callable(self, "on_enemy_death"))
	spawn_player(player_spawn.position)
	set_new_spawn_time()
	gui.enemies_left = enemy_total
	gui.set_enemy_counter()

func _process(delta):
	if player == null:
		if exit_stage_delay.is_stopped():
			exit_stage_delay.start()
			stage_animator.play("fade_out")

func spawn_player(location : Vector2):
	player = player_scene.instantiate()
	add_child(player)
	player.position = location
	player.state = AttackCharacter.CharacterState.IDLE
	if scene_camera != null:
		player.camera = scene_camera

func spawn_enemy(location : Vector2):
	# stop spawning enemies once the total has been hit.
	if enemies_spawned >= enemy_total:
		enemy_spawn_timer.stop()
		return
	
	var new_enemy : Enemy = enemy_scene.instantiate()
	add_child(new_enemy)
	new_enemy.position = location
	new_enemy.target = player
	enemies_spawned += 1

func set_new_spawn_time():
	var new_time = randf_range(min_spawn_time, max_spawn_time)
	enemy_spawn_timer.wait_time = new_time
	enemy_spawn_timer.start()

func on_enemy_death():
	enemies_defeated += 1
	
	if enemies_defeated >= enemy_total:
		exit_blocker_right.disabled = true
		stage_animator.play("exit_arrow_loop")

func _on_enemy_spawn_timer_timeout():
	if spawn_left:
		spawn_enemy(left_enemy_spawn.position)
		spawn_left = false
	else:
		spawn_enemy(right_enemy_spawn.position)
		spawn_left = true
	
	set_new_spawn_time()

func exit_stage():
	var level = load(next_scene)
	var level_scene = level.instantiate()
	GlobalSignals.emit_signal("change_scene", level_scene)

func _on_exit_stage_delay_timeout():
	exit_stage()

func _on_stage_exit_body_entered(body):
	player.state = AttackCharacter.CharacterState.LOCKED
	exit_stage_delay.start()
	stage_animator.play("fade_out")
