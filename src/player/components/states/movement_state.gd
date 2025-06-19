extends CharacterState
class_name MovementState


## The character's movement speed.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s") var speed: float = 300
## The character's movement acceleration.
@export_custom(PROPERTY_HINT_NONE, "suffix:px/s²") var acceleration: float = 2000.0

## State to change to when the player 
@export var attack_state: StateMachineState = null
@export var stuck_state: StateMachineState = null


# Called every physics tick when this state is active.
func _physics_process(delta):
	if !is_instance_valid(character): return
	if mpp and !mpp.is_ready:
		return
	if !character.can_move: return
	var direction = Input.get_vector(mpp.ma("ui_left"), mpp.ma("ui_right"),mpp.ma("ui_up"),mpp.ma("ui_down")).normalized()
	handle_movement(delta,direction)
	character.move_and_slide()
 
func handle_movement(delta:float,direction:Vector2):
	character.velocity.x = move_toward(character.velocity.x, speed * direction.x, acceleration * delta)
	if !character.is_on_wall():
		character.velocity.y += character.gravity * delta

# Called when there is an input event when this state is active.
#func _unhandled_input(event: InputEvent) -> void:
	# Change to the attack state if the player attacked
	#if event.is_action_pressed("ui_accept"):
		#get_state_machine().current_state = attack_state
