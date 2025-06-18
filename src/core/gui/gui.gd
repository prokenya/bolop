extends Control
class_name Gui


@onready var abilities_selector: PanelContainer = $HBoxContainer/VBoxContainer/abilities_selector
@onready var next_level_button: Button = %next_level_button

func _ready() -> void:
	G.main.round_ended.connect(_round_ended)
	G.main.round_started.connect(_round_started)
	G.main.in_lobby.connect(_round_ended)
	G.local_player_despawned.connect(_local_player_despawned)

func _round_ended():
	if MPIO.mpc.is_server:
		next_level_button.visible = true
	abilities_selector.show_abilities_selector()

func _round_started():
	next_level_button.visible = false
	abilities_selector.show_abilities_selector(false)
	abilities_selector.emit_set_abilities()

func _local_player_despawned():
	abilities_selector.show_abilities_selector()

func _on_next_level_button_pressed() -> void:
	G.main.load_level()
