extends Area2D
class_name Hurtbox

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))


func _on_area_entered(hitbox : Hitbox):
	# cannot recieve damage when already reacting to hit
	if owner.invulnerable: return
	# cannot recieve damage if no hitbox found
	if hitbox == null: return
	# do not take damage from disabled hitboxes
	if hitbox.collision_shape.disabled: return
	# send message to owner to recieve the hit
	elif owner.has_method("receive_hit"):
		var hit_direction = hitbox.character.global_position - owner.global_position
		hit_direction.y = 0
		var knockback_mulitplier = hitbox.damage / hitbox.base_damage
		owner.set_knockback_force(knockback_mulitplier)
		owner.receive_hit(hitbox.damage, hit_direction.normalized())
