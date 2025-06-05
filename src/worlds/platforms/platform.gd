extends AnimatableBody2D
class_name Platform

func connect_player(player: Player) -> bool:
	return true

@export var animate:bool = false
@export var next_pos:Vector2
@export var duration:int = 5
func _ready() -> void:
	if !animate: return
	var tween = create_tween().set_loops()
	tween.tween_property(self,"position",position+next_pos,duration)
	tween.tween_property(self,"position",position,duration)
	
