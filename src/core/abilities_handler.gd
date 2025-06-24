extends Node
class_name AbilitiesHandler
@export var abilities_scenes:PackedScene

func _ready() -> void:
	G.local_player_ready.connect(_local_player_ready)

func _local_player_ready():
	pass
