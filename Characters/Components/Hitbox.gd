extends Area2D
class_name Hitbox

@export var base_damage : int = 1


var character : AttackCharacter 
var damage : int = 0

@onready var collision_shape = $CollisionShape2D

func _ready():
	damage = base_damage
