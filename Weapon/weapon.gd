extends Sprite2D
class_name Weapon

@onready var flash_timer = $FlashTimer

func flash_sprite():
	material.set_shader_parameter("flash_modifier", 1)
	
	flash_timer.start()

func _on_flash_timer_timeout():
	material.set_shader_parameter("flash_modifier", 0)
