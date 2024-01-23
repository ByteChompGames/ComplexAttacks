extends CharacterBody2D
class_name AttackCharacter

enum CharacterState
{
	IDLE,
	MOVE,
	ATTACK
}
@export var state = CharacterState.MOVE

@export var move_speed : float = 100

var attackCount : int = 0
var comboCount : int = 0
var attack_buffered : bool = false

@onready var character_sprite = $CharacterSprite
@onready var character_animations = $CharacterAnimations
@onready var attacks = $Attacks
@onready var attack_buffer = $AttackBuffer

func _ready():
	character_sprite.play()
	attackCount = attacks.get_child_count()

func _physics_process(delta):
	var input = move_input()
	match state:
		CharacterState.IDLE:
			set_character_animation("char_idle")
			if input != 0:
				state = CharacterState.MOVE
			return
		CharacterState.MOVE:
			set_character_animation("char_run")
			var move_direction = Vector2.RIGHT * input
			move_character(self, move_direction, move_speed)
			flip_direction(input);
			if input == 0:
				state = CharacterState.IDLE
			return
		CharacterState.ATTACK:
			return

func _input(event):
	if event.is_action_pressed("attack") and state != CharacterState.ATTACK:
		perform_attack()
	elif state == CharacterState.ATTACK:
		attack_buffer.start()
		attack_buffered = true

func perform_attack():
	if attack_buffered:
		attack_buffer.stop()
		attack_buffered = false
	
	var attack = get_attack()
	attack.start_attack()
	update_combo()

func get_attack() -> Attack:
	var selected_attack = attacks.get_child(comboCount)
	return selected_attack

func update_combo():
	comboCount += 1
	if comboCount >= attackCount:
		comboCount = 0

func flip_direction(input):
	if input > 0:
		character_sprite.scale.x = 1
	if input < 0:
		character_sprite.scale.x = -1

func get_direction() -> Vector2:
	return Vector2.RIGHT * character_sprite.scale.x

func move_input() -> float:
	var input = 0
	input = Input.get_axis("move_left", " move_right") # get value from -1 -> 1
	return input

func move_character(character : CharacterBody2D, direction : Vector2, force : float):
	character.velocity = direction * force
	character.move_and_slide()

func set_character_animation(animation : String):
	if character_animations.current_animation == animation: return
	else:
		character_animations.current_animation = animation
		character_sprite.play()

func set_state(stateID : int):
	state = stateID

func _on_attack_buffer_timeout():
	attack_buffered = false
	
	if state != CharacterState.ATTACK:
		perform_attack()
