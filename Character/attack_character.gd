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


@onready var character_sprite = $CharacterSprite
@onready var character_animations = $CharacterAnimations
@onready var attack_pool = $AttackPool



func _ready():
	character_sprite.play()

func _physics_process(delta):
	print(attack_pool.attack_buffered)
	
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
	if event.is_action_pressed("attack"):
		if state != CharacterState.ATTACK:
			attack_pool.perform_attack()
		else:
			attack_pool.buffer_attack()

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
