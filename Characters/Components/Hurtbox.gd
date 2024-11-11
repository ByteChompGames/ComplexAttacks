extends Area2D
class_name Hurtbox

signal on_hurt

func _ready():
	connect("area_entered", Callable( self, "_on_area_entered"))

func _on_area_entered(hitbox : Hitbox):
	# cannot recieve damage when already reacting to hit
	if owner.invulnerable: return
	# cannot recieve damage if no hitbox found
	if hitbox == null: return
	# do not take damage from disabled hitboxes
	if hitbox.collision_shape.disabled: return
	
	if owner.has_method("receive_hit"):
		#get the direction of the hit
		var hit_direction = hitbox.character.global_position - owner.global_position
		hit_direction.y = 0
		# if attack parried, ignore hit and send signal to attacker
		if owner.in_parry:
			hitbox.was_parried.emit(-hit_direction.normalized())
			return
		#otherwise, hit has landed.
		# get the knockback force of the hit.
		var knockback_mulitplier = hitbox.damage / hitbox.base_damage
		owner.set_knockback_force(knockback_mulitplier)
		# if blocking, reduce damage before recieving hit
		if owner.in_block:
			hitbox.was_blocked.emit(-hit_direction.normalized())
			owner.receive_hit(hitbox.damage / 2, hit_direction.normalized())
			on_hurt.emit()
		else:
			# send message to owner to recieve the hit
			owner.receive_hit(hitbox.damage, hit_direction.normalized())
			on_hurt.emit()


func _on_hitbox_was_blocked(direction):
	owner.was_blocked(direction)
	on_hurt.emit()


func _on_hitbox_was_parried(direction):
	owner.was_parried(direction)
	on_hurt.emit()
