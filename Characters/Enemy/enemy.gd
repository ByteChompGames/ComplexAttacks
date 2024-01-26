extends AttackCharacter
class_name Enemy

@onready var character_sprite = $EnemySprite
@onready var weapon_sprite = $EnemySprite/Weapon
@onready var character_animations = $CharacterAnimations
@onready var attack_pool = $AttackPool

func _ready():
	character_sprite.play()
