extends AttackCharacter
class_name Enemy

@export var attack_range : float = 24
@export var target : AttackCharacter

@onready var character_sprite = $EnemySprite
@onready var weapon_sprite = $EnemySprite/Weapon
@onready var character_animations = $CharacterAnimations
@onready var attack_pool = $AttackPool

func _ready():
	character_sprite.play()

func _physics_process(delta):
	match state:
		CharacterState.IDLE:
			set_character_animation(character_animations, "char_idle")
			
			if target != null:
				state = CharacterState.MOVE
			return
		CharacterState.MOVE:
			set_character_animation(character_animations, "char_run")
			# move the enemy towards the target
			var move_direction = target.global_position - global_position
			move_character(self, move_direction.normalized(), move_speed)
			flip_direction(character_sprite, move_direction.normalized().x)
			#attack if in range
			if abs(move_direction.x) < attack_range:
				state = CharacterState.ATTACK
				attack_pool.perform_attack()
			return
		CharacterState.ATTACK:
			return

# sprites
func flash_sprites():
	character_sprite.flash_sprite()
	weapon_sprite.flash_sprite()

func wait_for_charge():
	var current_attack = attack_pool.get_current_attack()
	
	if !current_attack.charge_attack:
		attack_pool.release_attack()
		return
	
	if current_attack.charge_amount_reached():
		attack_pool.release_attack()

func continue_combo():
	# end combo if combo order complete
	if attack_pool.combo_count == attack_pool.combo_order.size():
		return
	
	# continue to next attack
	attack_pool.attack_buffered = true
