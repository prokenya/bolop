extends Area2D

@export var player:Player

@onready var state_machine: StateMachine = $"../StateMachine"

@export var stuck_state:StateMachineState = null
@onready var platforms:Array[Platform]
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect("body_entered",_entered)
	connect("body_exited",_exited)

func _entered(body:Node2D):
	if !is_multiplayer_authority(): return
	if body is Platform:
		platforms.append(body)
		if player.current_platform:
			return
		
		#body.connect_player(player)
		player.current_platform = body
		current_platform_path = body.get_path()
		if state_machine.current_state in [AttackState,StuckState]:return
		player.state_machine.current_state = stuck_state
		player.sprite.rotation = Vector2(body.global_position - player.global_position).angle() - PI/2
	
func _exited(body:Node2D):
	if body is Platform:
		if body in platforms:
			platforms.erase(body)

@export var current_platform_path: NodePath:
	set(value):
		current_platform_path = value
		if not is_multiplayer_authority():
			var node = get_node_or_null(value)
			if node and node is Platform:
				player.current_platform = node
	get: return current_platform_path
