extends CharacterBody2D

@onready var character_sprite = $CharacterSprite

func _ready():
	character_sprite.play()
