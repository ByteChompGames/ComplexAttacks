extends CharacterBody2D
class_name AttackCharacter

enum CharacterState
{
	MOVE,
	ATTACK
}
@export var state = CharacterState.MOVE

@export var move_speed : float = 100

@onready var character_sprite = $CharacterSprite
@onready var character_animations = $CharacterAnimations
@onready var attack = $Attack

func _ready():
	character_sprite.play()

func _physics_process(delta):
	
	match state:
		CharacterState.MOVE:
			var input = move_input()
			var move_direction = Vector2.RIGHT * input
			move_character(self, move_direction, move_speed)
			if input != 0:
				set_character_animation("char_run")
			else:
				set_character_animation("char_idle")
			return
		CharacterState.ATTACK:
			return

func _input(event):
	if event.is_action_pressed("attack"):
		attack.start_attack()


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

func set_state(stateID : int):
	state = stateID
