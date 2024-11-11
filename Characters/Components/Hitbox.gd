extends Area2D
class_name Hitbox

signal was_parried(direction : Vector2)

signal was_blocked(direction : Vector2)

@export var base_damage : int = 1


var character : AttackCharacter 
var damage : int = 0

@onready var collision_shape = $CollisionShape2D

func _ready():
	damage = base_damage
