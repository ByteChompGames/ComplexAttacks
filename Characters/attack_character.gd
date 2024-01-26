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

var charging : bool = false

func flip_direction( character_sprite : AnimatedSprite2D, direction : float):
	if direction > 0:
		character_sprite.scale.x = 1
	if direction < 0:
		character_sprite.scale.x = -1

func get_direction(character_sprite : AnimatedSprite2D) -> Vector2:
	return Vector2.RIGHT * character_sprite.scale.x

func move_character(character : CharacterBody2D, direction : Vector2, force : float):
	character.velocity = direction * force
	character.move_and_slide()

func set_character_animation(character_animations : AnimationPlayer, animation : String):
	if character_animations.current_animation == animation: return
	else:
		character_animations.current_animation = animation

func set_state(stateID : int):
	state = stateID
