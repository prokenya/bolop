extends Node
class_name Main

@onready var mpc: MultiPlayCore = $MultiPlayCore

@onready var level = get_node("MultiPlayCore/Level")

@export var worlds:Array[String]
@export var current_world_id:int

@export var live_players_count:int

var game_started:bool = false
var is_round_started:bool = false

signal in_lobby
signal round_started
signal round_ended

var kicked_players:Array[int]

func _ready() -> void:
	G.player_despawned.connect(_global_player_despawned)
	mpc.scene_loaded.connect(_scene_changed)
	mpc.player_disconnected.connect(_player_disconnected)

func _on_multi_play_core_player_connected(player: MPPlayer) -> void:
	if !multiplayer.is_server():return
	
	if game_started:
		kicked_players.append(player.player_id)
		mpc._kick_player_request(player.player_id,8)
		return

func _global_player_despawned():
	if multiplayer.is_server():
		live_players_count -= 1
		#print_debug("despawned -> " + str(mpc.local_player.player_index))
	if live_players_count <= 1:
		round_ended.emit()
		is_round_started = false

func _scene_changed():
	if !multiplayer.is_server():return
	live_players_count = mpc.players.players.size()
	current_world_id = worlds.find(mpc.current_scene.scene_file_path)
		
	if current_world_id == 0:
		game_started = false
		G.emit_for_all(in_lobby)
	else:
		game_started = true
		G.emit_for_all(round_started)
	#print_debug("scene loaded id: " + str(current_world_id))

func _player_disconnected(player:MPPlayer):
	if multiplayer.is_server() and player.player_id not in kicked_players:
		live_players_count -= 1


func load_level(id:int = -1):
	if id == -1:
		var game_worlds = worlds.duplicate(true)
		game_worlds.pop_front()
		MPIO.mpc.load_scene(game_worlds.pick_random(),true)
	else:
		MPIO.mpc.load_scene(worlds[id],true)
		
