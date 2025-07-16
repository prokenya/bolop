class_name Platform
extends RigidBody2D

@export_range(0, 16, 0.1) var joint_softness: float = 16
@export var collision_shape: CollisionShape2D
@export var collision_polygon: CollisionPolygon2D

var tween: Tween
var base_scale: Vector2
var current_scale: Vector2

@onready var joint: PinJoint2D = PinJoint2D.new()
@onready var timer: Timer = Timer.new()


func _ready():
	if collision_shape: base_scale = collision_shape.scale
	elif collision_polygon: base_scale = collision_polygon.scale
	current_scale = base_scale
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
		timer.timeout.connect(animate_scale.bind(base_scale))

	timer.wait_time = time
	timer.stop()
	timer.start()
	
	current_scale += Vector2(add_factor,add_factor)
	
	animate_scale(current_scale)


func animate_scale(target_scale: Vector2):
	if tween:
		tween.kill()
	tween = create_tween()

	if collision_shape:
		tween.tween_property(collision_shape, "scale", target_scale, 0.3)
	if collision_polygon:
		tween.tween_property(collision_polygon, "scale", target_scale, 0.3)
	if target_scale == base_scale:
		current_scale = base_scale
