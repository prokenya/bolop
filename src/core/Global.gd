extends Node
class_name Global

signal set_abilities(abilities:Dictionary)
signal player_despawned
signal local_player_ready
signal local_player_despawned
@onready var main:Main = get_node("/root/Main")
@onready var data = Data.load_or_create()

func _ready() -> void:
	await MPIO.mpc_ready
	MPIO.mpc.connected_to_server.connect(connect_signals)
	MPIO.mpc.server_started.connect(connect_signals)

func connect_signals(args):
	MPIO.mpc.local_player.player_despawned.connect(func():local_player_despawned.emit())
	MPIO.mpc.local_player.player_ready.connect(func():local_player_ready.emit())


func emit_for_all(si:Signal):
	rpc("_net_emit_for_all",si)

@rpc("authority", "call_local", "reliable")
func _net_emit_for_all(si:Signal):
	si.emit()
