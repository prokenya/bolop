class_name StuckState
extends MovementState

@export var movement_state: StateMachineState

var fixed_distance: float = -20
var last_direction: Vector2

var last_platform_position: Vector2

@onready var pc_component: Area2D = $"../../PC component"


func _ready() -> void:
	connect("state_exited", _state_exited)
	connect("state_entered", _state_entered)


func handle_movement(delta: float, direction: Vector2) -> void:
	var raycast := character.GroundRay as RayCast2D
	raycast.force_raycast_update()

	stuck()

	if not raycast.is_colliding():
		var dir = Vector2(character.current_platform.global_position - character.global_position)
		character.velocity = dir
		character.sprite.rotation = dir.angle() - PI / 2
		return
	var collision_point: Vector2 = raycast.get_collision_point()
	var wall_normal: Vector2 = raycast.get_collision_normal().normalized()

	var current_distance: float = (collision_point - character.global_position).dot(wall_normal)
	var dist_error: float = fixed_distance - current_distance
	var vel_normal: float = dist_error * 15

	var tangent: Vector2 = Vector2(-wall_normal.y, wall_normal.x)
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
	character.sprite.rotation = wall_normal.angle() + PI / 2

	if Input.is_action_just_pressed(mpp.ma("ui_accept")):
		if pc_component.platforms.size() > 1:
			var last_platform = pc_component.platforms.pop_back()
			if last_platform != null:
				pc_component.platforms.push_front(last_platform)
				character.current_platform = last_platform
				character.sprite.rotation = Vector2(last_platform.global_position - character.global_position).angle() - PI / 2
				return
		get_state_machine().current_state = movement_state


func stuck():
	if character.current_platform:
		var platform = character.current_platform
		var platform_delta = platform.global_position - last_platform_position
		#print(platform_delta)
		character.global_position += platform_delta
		last_platform_position = platform.global_position


func jump():
	var angle_from_up = Vector2.UP.angle_to(Vector2(sin(character.rotation), -cos(character.rotation)))

	if absf(angle_from_up) < deg_to_rad(120):
		var direction = Vector2(sin(character.sprite.rotation), -cos(character.sprite.rotation)).normalized()
		var jump_dir = -(Vector2.UP + direction).normalized()
		character.velocity = character.JUMP_VELOCITY * jump_dir


func _state_entered():
	last_platform_position = character.current_platform.global_position


func _state_exited():
	jump()
	character.current_platform = null
	character.sprite.rotation = 0
