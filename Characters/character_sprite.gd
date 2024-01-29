extends AnimatedSprite2D
class_name CharacterSprite

@onready var flash_timer = $FlashTimer
@onready var invul_timer = $InvulTimer

func _process(delta):
	if owner.invulnerable && invul_timer.is_stopped():
		invul_timer.start()
	elif !owner.invulnerable && !invul_timer.is_stopped():
		_on_invul_timer_timeout()

func flash_sprite(alpha : float):
	material.set_shader_parameter("flash_modifier", alpha)
	
	flash_timer.start()

func _on_flash_timer_timeout():
	material.set_shader_parameter("flash_modifier", 0)


func _on_invul_timer_timeout():
	if !owner.invulnerable:
		modulate.a = 1
		invul_timer.stop()
	else:
		if modulate.a == 1:
			modulate.a = 0
		else:
			modulate.a = 1
	
