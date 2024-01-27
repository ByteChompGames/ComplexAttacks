extends Area2D
class_name Hurtbox

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))


func _on_area_entered(hitbox : Hitbox):
	
	# cannot recieve damage if no hitbox found
	if hitbox == null:
		return
	# do not recieve damage from character's own weapon
	if hitbox == owner.weapon_sprite.hit_box:
		return
	# send message to owner to recieve the hit
	if owner.has_method("receive_hit"):
		var hit_direction = hitbox.global_position - owner.global_position
		hit_direction.y = 0
		owner.receive_hit(hitbox.damage, hit_direction.normalized(), owner.health)
