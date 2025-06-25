class_name AbilitiesHandler
extends Node

@export var abilities_scenes: Array[PackedScene]
@export var mpc: MultiPlayCore

var local_abilities_set: Dictionary
var current_ability_index: int = -1

@onready var spawner = MultiplayerSpawner.new()
@onready var local_player:Player

func _ready() -> void:
	add_child(spawner)
	spawner.spawn_path = self.get_path()

	for path in G.data.abilities_paths:
		spawner.add_spawnable_scene(path)
		abilities_scenes.append(load(path))
	if is_multiplayer_authority():
		G.local_player_spawned.connect(_local_player_spawned)
		G.set_abilities.connect(func(ab): local_abilities_set = ab)


func spawn_ability_node(index, property_list:Dictionary):
	rpc_id(1, "_net_spawn_ability_node", index, property_list)


func _local_player_spawned(player: Player):
	local_player = player
	if player.abilities_component.action_pressed.is_connected(_local_action_pressed): return

	player.abilities_component.action_pressed.connect(_local_action_pressed)
	player.abilities_component.action_released.connect(_local_action_released)


func _local_action_pressed(action_index):
	current_ability_index = local_abilities_set[action_index]
	match current_ability_index:
		0:spawn_ability_node(current_ability_index,{"global_position":local_player.global_position})
		_:return


func _local_action_released(action_index):
	match current_ability_index:
		_:return
	current_ability_index = -1

@rpc("any_peer", "call_local", "reliable")
func _net_spawn_ability_node(index: int, property_list: Dictionary) -> void:
	if !multiplayer.is_server():return
	if index < 0 or index > abilities_scenes.size():
		push_error("Ability index out of bounds: %s" % index)
		return


	var inst = abilities_scenes[index].instantiate()

	for property in property_list.keys():
		if inst.has_method("set") and property in inst:
			inst.set(property, property_list[property])
		else:
			push_warning("Property '%s' does not exist on ability node" % property)
	add_child(inst,true)
