extends Area2D
class_name Ability

@export var lifetime:float = 2

func _ready() -> void:
	if !multiplayer.is_server():
		return
	_handle_ability()
func _check_and_free() -> void:
	if is_inside_tree() and is_multiplayer_authority():
		queue_free()

func _handle_ability():
	pass
