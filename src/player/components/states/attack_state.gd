extends MovementState
class_name AttackState

@export_range(0.1,2,0.1) var gravity_scale:float = 0.3


func handle_movement(delta:float,direction:Vector2):
	character.velocity.x = move_toward(character.velocity.x, speed * direction.x, acceleration * delta)
	if !character.is_on_wall():
		character.velocity.y = character.gravity * delta * gravity_scale
