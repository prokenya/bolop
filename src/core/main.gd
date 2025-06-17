extends Node
class_name Main

@onready var mpc: MultiPlayCore = $MultiPlayCore

@onready var level = get_node("MultiPlayCore/Level")

@export var worlds:Array[String]


func _on_multi_play_core_player_connected(player: MPPlayer) -> void:
	if !multiplayer.is_server():return
	
	if mpc.current_scene.scene_file_path != worlds[0]:
		mpc._kick_player_request(player.player_id,8)
		return

func testf():
	MPIO.mpc.players.get_player_by_id(1).despawn_node()
	await  get_tree().create_timer(5).timeout
	MPIO.mpc.load_scene("res://src/worlds/world1.tscn",true)
