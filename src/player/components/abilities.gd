extends Control

@export var player: Player
@export var state_machine: StateMachine
@export_category("states")
@export var attack_state: StateMachineState
@export var stuck_state: StateMachineState
@export var movement_state: StateMachineState

var actions: Array[String] = ["LMB", "MMB", "RMB"]
var currnet_action_index: int = -1

@onready var abilities: Array[TextureProgressBar] = [%ability1, %ability2, %ability3]

@onready var abilities_timers: Array[Timer] = [%ability_timer1, %ability_timer2, %ability_timer3]


func _physics_process(delta: float) -> void:
	animate_actions_cooldown()


func _input(event: InputEvent) -> void:
	for action in actions:

		if Input.is_action_just_pressed(action):
			if currnet_action_index != -1: continue
			currnet_action_index = actions.find(action)

			if !abilities_timers[currnet_action_index].is_stopped(): continue
			state_machine.current_state = attack_state
			return

		if Input.is_action_just_released(actions[currnet_action_index]):
			if abilities_timers[currnet_action_index].is_stopped():
				abilities_timers[currnet_action_index].start()
			currnet_action_index = -1
			state_machine.current_state = stuck_state if player.current_platform else movement_state
			return


func animate_actions_cooldown():
	for action_index in range(len(actions)):
		var timer: Timer = abilities_timers[action_index]
		var progress = clamp((timer.time_left / timer.wait_time) * 100, 0, 100)
		abilities[action_index].value = progress
