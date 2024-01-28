extends Area2D
class_name Hurtbox

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))


func _on_area_entered(hitbox : Hitbox):
	# cannot recieve damage when already reacting to hit
	if owner.state == AttackCharacter.CharacterState.HURT: return
	# cannot recieve damage if no hitbox found
	if hitbox == null: return
	# do not take damage from disabled hitboxes
	if hitbox.collision_shape.disabled: return
	# send message to owner to recieve the hit
	elif owner.has_method("receive_hit"):
		var hit_direction = hitbox.owner.global_position - owner.global_position
		hit_direction.y = 0
		owner.receive_hit(hitbox.damage, hit_direction.normalized())
