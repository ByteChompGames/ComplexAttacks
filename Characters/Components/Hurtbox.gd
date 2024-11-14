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
		
		# recieve hit as normal if not blocking
		if !owner.in_block:
			# send message to owner to recieve the hit
			owner.receive_hit(hitbox.damage, hit_direction.normalized())
			on_hurt.emit()
			return
		else:
			# is the owner blocking in the direction of the attack
			var block_angle = hit_direction.dot(owner.get_direction(owner.character_sprite))
			print(block_angle)
			
			# if not facing attack, block was unsuccessful
			if block_angle <= 0:
				owner.receive_hit(hitbox.damage, hit_direction.normalized())
				on_hurt.emit()
				return
			else:
				# if attack parried, ignore hit and send signal to attacker
				if owner.in_parry:
					hitbox.was_parried.emit(-hit_direction.normalized())
					return
				else:
					# attack was blocked
					# get the knockback force of the hit.
					var knockback_mulitplier = hitbox.damage as float / hitbox.base_damage as float
					owner.set_knockback_force(knockback_mulitplier)
					# call the attack to be blocked
					hitbox.was_blocked.emit(-hit_direction.normalized())
					owner.receive_hit(0, hit_direction.normalized())

func _on_hitbox_was_blocked(direction):
	owner.was_blocked(direction)
	on_hurt.emit()


func _on_hitbox_was_parried(direction):
	owner.was_parried(direction)
	on_hurt.emit()
