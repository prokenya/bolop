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
@export var can_move:bool = false

func _ready():
	if is_multiplayer_authority():
		camera.make_current()
		abilities_set = {0: 0, 1: 0, 2: 0}
		G.connect("set_abilities",func(ab):abilities_set = ab;can_move = true)
		if multiplayer.is_server():
			test.visible = true
			test.connect("pressed",testf)
	mpp.player_ready.connect(_on_player_ready)
	mpp.handshake_ready.connect(_on_handshake_ready)

@onready var test: Button = $test

func testf():
	MPIO.mpc.load_scene("res://src/worlds/world1.tscn")
#region mpp calls

# Whn player node is ready, this only emit locally.
func _on_player_ready():
	print("Player's now ready!")
	if !is_multiplayer_authority(): return
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT
	position.x += (mpp.player_index * 128)

# On handshake data is ready. This emits to everyone in the server. You can also use it to init something for all players.
func _on_handshake_ready(hs):
	player_name.text = hs["player_name"]
	print_rich("[color=green]player {id}({name}) -> {hs}[/color]".format({"id": mpp.player_index,"name":hs["player_name"],"hs":hs})
	)
#endregion

	

#func _physics_process(delta):
	#if !mpp.is_ready:
		#return
		#
		#
#
	## Handle jump.
	#if Input.is_action_just_pressed(mpp.ma("ui_accept")):
		#velocity = JUMP_VELOCITY * Vector2(cos(rotation), sin(rotation))
#
#
	## Get the input direction and handle the movement/deceleration
	## Using UI input actions because it's built-in.
	#var direction = Input.get_axis(mpp.ma("ui_left"), mpp.ma("ui_right"))
	#if player_state == player_states.ON_PLATFORM:
		#follow_point.progress += direction * 5
		#return	
	#var player_movement_direction = Vector2(gravity_direction.y,-gravity_direction.x)
	#if direction:
		#if player_movement_direction.x != 0:
			#velocity.x = direction * SPEED * player_movement_direction.x
		#if player_movement_direction.y != 0:
			#velocity.y = direction * SPEED * player_movement_direction.y
	#elif is_on_wall():
		#velocity.x = move_toward(velocity.x, 0, SPEED)
		#velocity.y = move_toward(velocity.y, 0, SPEED)
	#if not is_on_wall():
		#print("gravity")
		#velocity += 980 * delta * gravity_direction
		#
	#
	#move_and_slide()
