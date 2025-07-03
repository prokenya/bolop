extends Ability

var draw_line_now:bool = false
var collision_point:Vector2
func _ready() -> void:
	super()
	#_handle_ability()

func _handle_ability():
	var firs_ray = RayCast2D.new()
	
	firs_ray.target_position = Vector2(3000,0)
	firs_ray.set_collision_mask_value(1, true)
	firs_ray.set_collision_mask_value(3, true)
	firs_ray.set_collision_mask_value(4, true)

	add_child(firs_ray)
	firs_ray.force_raycast_update()
	var collider = firs_ray.get_collider()
	collision_point = to_local(firs_ray.get_collision_point())
	if collider:
		print(collider)
		if collider is Platform or collider is Player:
			#if multiplayer.is_server():
				#collider.add_scale(0.2, 10)
			draw_line_now = true
	else:
		print("Ray didn't hit anything.")
		collision_point = firs_ray.target_position
		draw_line_now = true
	queue_redraw()
	await get_tree().create_timer(lifetime).timeout
	draw_line_now = false
	call_deferred("_check_and_free")
	
func _draw():
	if draw_line_now:
		draw_line(Vector2.ZERO, collision_point, Color.AQUA, 10, true)

	
