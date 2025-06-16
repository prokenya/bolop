extends PanelContainer

@onready var selector: TextureRect = %selector
@onready var abilities_set_container: HBoxContainer = %abilities_set
@onready var abilities_set_separation:int = abilities_set_container["theme_override_constants/separation"]
@onready var abilities_set_count: int = abilities_set_container.get_child_count()

@export var abilities_textures:Array[Texture]
@onready var abilities_count:int = abilities_textures.size()

var selector_current_id: int = 1

var abilities_set: Dictionary = {0: 0, 1: 0, 2: 0}

func _input(event: InputEvent) -> void:
	if !visible:return
	if Input.is_action_just_pressed("ui_right"):
		move_selector(1)
	elif Input.is_action_just_pressed("ui_left"):
		move_selector(-1)
	if Input.is_action_just_pressed("ui_up"):
		set_ability(-1)
	elif Input.is_action_just_pressed("ui_down"):
		set_ability(1)
	if Input.is_action_just_pressed("ui_accept"):
		selector.visible = !selector.visible
		selector_current_id = 1
		if !selector.visible:
			G.emit_signal("set_abilities",abilities_set)
	
func move_selector(direction: int) -> void:
	var new_id = selector_current_id + direction
	if new_id >= 0 and new_id < abilities_set_count:
		selector_current_id = new_id
		selector.position.x += (64 + abilities_set_separation) * direction

func set_ability(direction:int):
	var ability:TextureRect = abilities_set_container.get_children()[selector_current_id]
	var ability_current_id: int = abilities_set[selector_current_id]
	var new_id = ability_current_id + direction
	
	if new_id < 0: 
		ability_current_id = abilities_count -1
	elif new_id >= abilities_count:
		ability_current_id = 0
	else:
		ability_current_id = new_id
		
	ability.texture = abilities_textures[ability_current_id]
	abilities_set[selector_current_id] = ability_current_id
