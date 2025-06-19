extends CharacterBody2D
class_name  Player
const SPEED = 300.0
const JUMP_VELOCITY = -700.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var gravity_direction:Vector2 = Vector2.DOWN
# Get the MultiPlay Player node, It's the parent of this node!
@onready var mpp: MPPlayer = get_parent()

@onready var camera: Camera2D = $Camera2D
@onready var player_name: Label = $Sprite2D/player_name
@onready var sprite: Sprite2D = $Sprite2D
@onready var current_platform:Platform

@onready var state_machine: StateMachine = $StateMachine

@onready var GroundRay: RayCast2D = $GroundRay

@onready var abilities_label: Label = $Sprite2D/abilities_label
@export var abilities_set: Dictionary = {0: 0, 1: 0, 2: 0}:
	set(value):
		abilities_set = value
		abilities_label.text = str(abilities_set)
	get():
		return abilities_set

@onready var ability_timer_1: Timer = $abilities_timer/ability_timer1
@onready var ability_timer_2: Timer = $abilities_timer/ability_timer2
@onready var ability_timer_3: Timer = $abilities_timer/ability_timer3


@export var can_move:bool = false

func _ready():
	if is_multiplayer_authority():
		camera.make_current()
		abilities_set = {0: 0, 1: 0, 2: 0}
		G.connect("set_abilities",func(ab):abilities_set = ab;can_move = true)
	mpp.player_ready.connect(_on_player_ready)
	mpp.handshake_ready.connect(_on_handshake_ready)

@export var attack_state:StateMachineState
@export var movement_state:StateMachineState
@export var stuck_state:StateMachineState
func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("LMB"):
		state_machine.current_state = attack_state
	if Input.is_action_just_pressed("MMB"):
		state_machine.current_state = attack_state
	if Input.is_action_just_pressed("RMB"):
		state_machine.current_state = attack_state
		
	if Input.is_action_just_released("LMB"):
		if current_platform:
			state_machine.current_state = stuck_state
			return
		state_machine.current_state = movement_state
	if Input.is_action_just_released("MMB"):
		if current_platform:
			state_machine.current_state = stuck_state
			return
		state_machine.current_state = movement_state
	if Input.is_action_just_released("RMB"):
		if current_platform:
			state_machine.current_state = stuck_state
			return
		state_machine.current_state = movement_state
#region mpp calls

# Whn player node is ready, this only emit locally.
func _on_player_ready():
	#print("Player's now ready!")
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	position.x += (mpp.player_index * 128)

# On handshake data is ready. This emits to everyone in the server. You can also use it to init something for all players.
func _on_handshake_ready(hs):
	player_name.text = hs["player_name"]
	#print_rich("[color=green]player {id}({name}) -> {hs}[/color]".format({"id": mpp.player_index,"name":hs["player_name"],"hs":hs}))
#endregion
