extends AttackCharacter
class_name Enemy

@export var attack_range : float = 24
@export var target : AttackCharacter

var has_target : bool = false

@onready var character_sprite = $EnemySprite
@onready var weapon_sprite = $EnemySprite/Weapon
@onready var character_animations = $CharacterAnimations
@onready var attack_pool = $AttackPool
@onready var health = $Health
@onready var hit_invul_timer = $HitInvulTimer
@onready var character_audio = $CharacterAudio

func _ready():
	character_sprite.play()
	health.reset()

func _physics_process(delta):
	# reset state to idle if target lost
	if has_target and target == null:
		has_target = false
		state = CharacterState.IDLE
	
	match state:
		CharacterState.IDLE:
			set_character_animation(character_animations, "char_idle")
			
			if target != null:
				has_target = true
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
		CharacterState.HURT:
			move_character(self, -hit_direction, knockback_force)
			knockback_force -= knockback_deceleration * delta
			flip_direction(character_sprite, hit_direction.x)
			
			if knockback_force < 0:
				knockback_force = 0
				state = CharacterState.IDLE
			return

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

func set_weapon_damage(multiplier):
	var hitbox = weapon_sprite.hit_box
	hitbox.damage = hitbox.base_damage * multiplier

# sprites
func flash_sprites(alpha : float):
	character_sprite.flash_sprite(alpha)
	weapon_sprite.flash_sprite(alpha)

func wait_for_charge():
	# get the current attack
	var current_attack = attack_pool.get_current_attack()
	# release the attack immediately if it is not a charge attack
	if !current_attack.charge_attack:
		attack_pool.release_attack()
		return
	# release the attack if the charge amount is reached
	if current_attack.charge_amount_reached():
		attack_pool.release_attack()

func play_hurt_animation():
	set_character_animation(character_animations, "char_hurt")

func continue_combo():
	# end combo if combo order complete
	if attack_pool.combo_count == attack_pool.combo_order.size():
		return
	
	# continue to next attack
	attack_pool.attack_buffered = true


func _on_hit_invul_timer_timeout():
	invulnerable = false
