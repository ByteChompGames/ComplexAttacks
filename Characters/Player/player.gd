extends AttackCharacter
class_name Player

@export var camera : Camera2D

@onready var character_sprite = $PlayerSprite
@onready var weapon_sprite = $PlayerSprite/Weapon
@onready var character_animations = $CharacterAnimations
@onready var state_machine = $StateMachine
@onready var attack_pool = $AttackPool
@onready var health = $Health
@onready var hit_invul_timer = $HitInvulTimer
@onready var character_audio = $CharacterAudio

func _ready():
	character_sprite.play()
	health.reset()

func play_character_animation(anim_name : String):
	set_character_animation(character_animations, anim_name)

# inputs
func move_input() -> float:
	var input = 0
	input = Input.get_axis("move_left", " move_right") # get value from -1 -> 1
	return input

func receive_hit(damage : float, direction : Vector2):
	# invulnerable to hits if already reacting to a hit
	if invulnerable: return 
	# cancel attack
	attack_pool.interupt_attack()
	# deal damage
	health.receive_damage(damage)
	#play audio
	character_audio.play_hurt()
	# setup knockback
	hit_direction = direction
	knockback_force = 50
	
	invulnerable = true
	hit_invul_timer.start()
	
	# enter hurt state
	state = CharacterState.HURT
	set_character_animation(character_animations, "char_hurt")
	flash_sprites(0.5)
	camera.apply_shake()

func set_weapon_damage(multiplier):
	var hitbox = weapon_sprite.hit_box
	hitbox.damage = hitbox.base_damage * multiplier

# sprites
func flash_sprites(alpha : float):
	character_sprite.flash_sprite(alpha)
	weapon_sprite.flash_sprite(alpha)

func _on_hit_invul_timer_timeout():
	invulnerable = false
