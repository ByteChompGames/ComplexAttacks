extends AttackCharacter
class_name Player

@onready var character_sprite = $PlayerSprite
@onready var weapon_sprite = $PlayerSprite/Weapon
@onready var character_animations = $CharacterAnimations
@onready var attack_pool = $AttackPool
@onready var health = $Health

func _ready():
	character_sprite.play()

func _physics_process(delta):
	var input = move_input()
	match state:
		CharacterState.IDLE:
			set_character_animation(character_animations, "char_idle")
			
			if input != 0:
				state = CharacterState.MOVE
			return
		CharacterState.MOVE:
			set_character_animation(character_animations, "char_run")
			
			var move_direction = Vector2.RIGHT * input
			move_character(self, move_direction, move_speed)
			flip_direction(character_sprite, input);
			
			if input == 0:
				state = CharacterState.IDLE
			return
		CharacterState.ATTACK:
			if !charging:
				attack_pool.release_attack()
			return
		CharacterState.HURT:
			move_character(self, -hit_direction, knockback_force)
			knockback_force -= knockback_deceleration * delta
			flip_direction(character_sprite, hit_direction.x)
			
			if knockback_force < 0:
				knockback_force = 0
				state = CharacterState.IDLE
			return

# inputs
func move_input() -> float:
	var input = 0
	input = Input.get_axis("move_left", " move_right") # get value from -1 -> 1
	return input

func _input(event):
	if event.is_action_pressed("attack"):
		charging = true
		if state != CharacterState.ATTACK:
			attack_pool.perform_attack()
		else:
			attack_pool.buffer_attack()
	
	if event.is_action_released("attack"):
		charging = false

func receive_hit(damage : float, direction : Vector2):
	# invulnerable to hits if already reacting to a hit
	if state == CharacterState.HURT: return 
	# cancel attack
	attack_pool.interupt_attack()
	# deal damage
	health.receive_damage(damage)
	# setup knockback
	hit_direction = direction
	knockback_force = 50
	# enter hurt state
	state = CharacterState.HURT
	set_character_animation(character_animations, "char_hurt")

# sprites
func flash_sprites():
	character_sprite.flash_sprite()
	weapon_sprite.flash_sprite()
