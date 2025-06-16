extends RigidBody2D
class_name Platform

@onready var joint:PinJoint2D = PinJoint2D.new()
@export_range(0,16,0.1) var joint_softness:float = 4
func _ready() -> void:
	gravity_scale = 0
	create_joint()

func create_joint():
	joint.position = Vector2.ZERO
	joint.softness = joint_softness
	add_child(joint)
	var pin = StaticBody2D.new()
	pin.top_level = true	
	pin.global_position = global_position
	pin.name = "pin"
	add_child(pin)
	joint.node_a = pin.get_path()
	joint.node_b = self.get_path()

var sig = 1
func _on_button_pressed() -> void:
	linear_velocity = Vector2(5000,5000) * sig
	sig = -sig
