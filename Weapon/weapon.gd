extends Sprite2D
class_name Weapon

@onready var flash_timer = $FlashTimer
@onready var hit_box = $Hitbox
@onready var hitbox_shape = $Hitbox/CollisionShape2D

func _ready():
	hit_box.character = owner
	toggle_hitbox(true)

func toggle_hitbox(is_active : bool):
	if is_active:
		hitbox_shape.set_deferred("disabled", false)
	else:
		hitbox_shape.set_deferred("disabled", true)

func flash_sprite(alpha : float):
	material.set_shader_parameter("flash_modifier", alpha)
	
	flash_timer.start()

func _on_flash_timer_timeout():
	material.set_shader_parameter("flash_modifier", 0)
