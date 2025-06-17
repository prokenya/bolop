extends Node
class_name Level

@onready var mpc = get_parent() as MultiPlayCore
@onready var main:Main = mpc.get_parent()

@export var spawner:MultiplayerSpawner = MultiplayerSpawner.new()



func _ready() -> void:
	if !spawner:
		add_child(spawner)
		spawner.spawn_path = self.get_path()
	register_scene_paths()

#@rpc("authority", "call_local", "reliable")
func register_scene_paths():
	for path in main.worlds:
		spawner.add_spawnable_scene(path)

func change_world(scene_path: String) -> Node:
	if not multiplayer.is_server():
		return

	#rpc("register_scene_path",scene_path)
	var packed_scene = load(scene_path) as PackedScene
	var scene = packed_scene.instantiate()

	clear_worlds()

	#spawner.add_spawnable_scene()
	add_child(scene)
	return scene

func clear_worlds():
	for c in get_children():
		if c != spawner:
			remove_child(c)
			c.queue_free()
