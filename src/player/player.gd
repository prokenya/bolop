class_name Player
extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -700.0

@export var abilities_set: Dictionary = { 0: 0, 1: 0, 2: 0 } :
	set(value):
		abilities_set = value
		abilities_component.set_abilities(abilities_set)
	get():
		return abilities_set

@export var can_move: bool = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_direction: Vector2 = Vector2.DOWN

# Get the MultiPlay Player node, It's the parent of this node!
@onready var mpp: MPPlayer = get_parent()

@onready var camera: Camera2D = $Camera2D
@onready var player_name: Label = $Sprite2D/player_name
@onready var sprite: Sprite2D = $Sprite2D
@onready var current_platform: Platform

@onready var state_machine: StateMachine = $StateMachine

@onready var GroundRay: RayCast2D = %GroundRay

@onready var abilities_component: AbilitiesComponent = $"abilities component"

@onready var mp_pos_sync: MPTransformSync = $MPTransformSync
@onready var mp_rot_sync: MPTransformSync = $Sprite2D/MPTransformSync
@onready var platform_component: Area2D = $"platform component"

@onready var head: Node2D = $head


func _ready():
	if is_multiplayer_authority():
		camera.make_current()
		abilities_set = { 0: 0, 1: 0, 2: 0 }
		G.connect("set_abilities", func(ab): abilities_set = ab)

	G.main.round_started.connect(func(): can_move = true)
	mpp.player_ready.connect(_on_player_ready)
	mpp.handshake_ready.connect(_on_handshake_ready)


func add_scale(add_scale: float, time: int = 10):
	scale += Vector2(add_scale, add_scale)
	await get_tree().create_timer(time).timeout
	scale = Vector2(0.3, 0.3)

func _input(event: InputEvent) -> void:
	var mouse_pos = get_global_mouse_position()
	head.look_at(mouse_pos)

#region mpp calls

# Whn player node is ready, this only emit locally.
func _on_player_ready():
	#print("Player's now ready!")
	#state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	position.x += (mpp.player_index * 128)


# On handshake data is ready. This emits to everyone in the server. You can also use it to init something for all players.
func _on_handshake_ready(hs):
	player_name.text = hs["player_name"]
	#print_rich("[color=green]player {id}({name}) -> {hs}[/color]".format({"id": mpp.player_index,"name":hs["player_name"],"hs":hs}))
#endregion
