extends CharacterBody2D
class_name  Player
const SPEED = 300.0
const JUMP_VELOCITY = -1000.0

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


func _ready():
	if is_multiplayer_authority():
		camera.make_current()
	mpp.player_ready.connect(_on_player_ready)
	mpp.handshake_ready.connect(_on_handshake_ready)

#region mpp calls

# Whn player node is ready, this only emit locally.
func _on_player_ready():
	if !is_multiplayer_authority(): return
	print("Player's now ready!")
	state_machine.process_mode = Node.PROCESS_MODE_INHERIT
		

# On handshake data is ready. This emits to everyone in the server. You can also use it to init something for all players.
func _on_handshake_ready(hs):
	player_name.text = hs["player_name"]
	print(mpp.player_index)
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
