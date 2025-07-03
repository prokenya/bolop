class_name Platform
extends RigidBody2D

@export_range(0, 16, 0.1) var joint_softness: float = 16

@onready var joint: PinJoint2D = PinJoint2D.new()
@onready var base_scale: Vector2
@onready var base_shape_scale
@onready var shape: CollisionShape2D
@onready var base_radius: float
@onready var base_height: float

@onready var timer: Timer = Timer.new()


func _ready():
	base_scale = scale
	shape = get_node("CollisionShape2D")
	if shape:
		assert(shape.shape is CapsuleShape2D)
		base_radius = shape.shape.radius
		base_height = shape.shape.height
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


func add_scale(add_factor: float, time: float = 10.0):
	if !timer.is_inside_tree():
		timer.one_shot = true
		add_child(timer)
		timer.timeout.connect(reset_scale)

	scale = base_scale * (1.0 + add_factor)
	shape.shape.radius = base_radius * (1.0 + add_factor)
	shape.shape.height = base_height * (1.0 + add_factor)


	timer.wait_time = time
	timer.stop()
	timer.start()


func reset_scale():
	shape.shape.radius = base_radius
	shape.shape.height = base_height
	scale = base_scale
