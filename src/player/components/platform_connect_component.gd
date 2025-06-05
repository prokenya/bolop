extends Area2D

@export var player:Player

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
		player.state_machine.current_state = stuck_state
		player.rotation = Vector2(body.global_position - player.global_position).angle() - PI/2
	
func _exited(body:Node2D):
	if body is Platform:
		if body in platforms:
			platforms.erase(body)
