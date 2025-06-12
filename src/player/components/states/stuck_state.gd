extends MovementState
class_name StuckState

@export var movement_state: StateMachineState
@onready var pc_component: Area2D = $"../../PC component"


func _ready() -> void:
	connect("state_exited",_state_exited)

var fixed_distance:float = -20
var last_direction:Vector2
func _physics_process(delta: float) -> void:
	super._physics_process(delta)
	

func handle_movement(delta: float, direction: Vector2) -> void:
	var raycast := character.GroundRay as RayCast2D
	raycast.force_raycast_update()
	if not raycast.is_colliding():
		print("noc")
		character.velocity = Vector2(character.current_platform.global_position - character.global_position)
		return
	
	var collision_point: Vector2 = raycast.get_collision_point()
	var wall_normal: Vector2 = raycast.get_collision_normal().normalized()
	

	var current_distance: float = (collision_point - character.global_position).dot(wall_normal)

	var dist_error: float = fixed_distance - current_distance
	
	var tangent: Vector2 = Vector2(-wall_normal.y, wall_normal.x)
	
	var vel_normal: float = dist_error * 15
	var vel_tangent: float
	
#region direction
	var tangent_input = direction.dot(tangent)
	
	if abs(tangent_input) > 0.1 or last_direction != direction:
		vel_tangent = sign(tangent_input) * speed
		last_direction = direction
	else:
		vel_tangent = 0

#endregion
				
	character.velocity = tangent * vel_tangent + wall_normal * -vel_normal
	
	character.rotation = wall_normal.angle() + PI/2
	
	if Input.is_action_just_pressed(mpp.ma("ui_accept")):
		if pc_component.platforms.size() > 1:
			var last_platform = pc_component.platforms.pop_back()
			if last_platform != null:
				pc_component.platforms.push_front(last_platform)
				character.current_platform = last_platform
				character.rotation = Vector2(last_platform.global_position - character.global_position).angle() - PI/2
				return
		get_state_machine().current_state = movement_state


#func _unhandled_input(event: InputEvent) -> void:
	#if Input.is_action_just_pressed(mpp.ma("ui_accept")):
		#get_state_machine().current_state = movement_state

func _state_exited():
	if absf(character.rotation) < deg_to_rad(120):
		var direction = Vector2(sin(character.rotation), -cos(character.rotation)).normalized()
		var jump_dir = -(Vector2.UP + direction).normalized()
		character.velocity = character.JUMP_VELOCITY * jump_dir
	character.current_platform = null
	character.rotation = 0
