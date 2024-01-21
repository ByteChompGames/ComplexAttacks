extends CharacterBody2D

@onready var character_sprite = $CharacterSprite
@onready var attack = $Attack

func _ready():
	character_sprite.play()

func _input(event):
	if event.is_action_pressed("attack"):
		attack.start_attack()
