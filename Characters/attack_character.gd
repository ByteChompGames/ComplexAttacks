extends CharacterBody2D
class_name AttackCharacter

enum CharacterState
{
	IDLE,
	MOVE,
	ATTACK,
	HURT,
	LOCKED
}

@export var state = CharacterState.MOVE
@export var move_speed : float = 100
@export var knockback_deceleration : float = 75
@export var base_knockback_force : float = 50

var charging : bool = false
var knockback_force : float = 50
var hit_direction : Vector2 = Vector2.ZERO
var invulnerable = false

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
	character.global_position.y = 105 # brute force character position to get around bug of characters falling into ground tiles

func set_character_animation(character_animations : AnimationPlayer, animation : String):
	if character_animations == null: return
	
	if character_animations.current_animation == animation: return
	else:
		character_animations.current_animation = animation

func set_state(stateID : int):
	state = stateID

func play_hurt_animation():
	pass

func receive_hit(damage : float, direction : Vector2):
	pass

func set_weapon_damage(multiplier):
	pass

func set_knockback_force(multiplier):
	knockback_force = base_knockback_force * multiplier

func emit_signal_on_death():
	pass
