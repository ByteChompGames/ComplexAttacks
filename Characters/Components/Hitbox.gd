extends Area2D
class_name Hitbox

@export var base_damage = 10


var character : AttackCharacter 
var damage = 0

@onready var collision_shape = $CollisionShape2D

func _ready():
	damage = base_damage
