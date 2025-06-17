extends Node
class_name Level

@onready var mpc = get_parent() as MultiPlayCore

@export var spawner:MultiplayerSpawner = MultiplayerSpawner.new()
func _ready() -> void:
	if !spawner:
		add_child(spawner)
		spawner.spawn_path = self.get_path()

#@rpc("authority", "call_local", "reliable")
#func register_scene_path(scene_path: String):
	#spawner.add_spawnable_scene(scene_path)
# Call this function deferred and only on the main authority (server).
func change_world(scene_path: String) -> Node:
	if not multiplayer.is_server():
		return

	#rpc("register_scene_path",scene_path)
	var packed_scene = load(scene_path) as PackedScene
	var scene = packed_scene.instantiate()

	for c in get_children():
		if c != spawner:
			remove_child(c)
			c.queue_free()

	#spawner.add_spawnable_scene()
	add_child(scene)
	return scene
