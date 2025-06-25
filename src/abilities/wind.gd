extends Area2D

@export var impulse_strenght:float = 5

func _ready() -> void:
	body_entered.connect(_body_entered)
	print("spawned")
	await get_tree().create_timer(0.3).timeout
	queue_free()

func _body_entered(body:Node2D):
	if body is not PhysicsBody2D:return
	var impulse:Vector2 = (body.global_position - global_position) * impulse_strenght
	
	if body is Platform:
		body = body as Platform
		body.apply_impulse(impulse)
	if body is Player:
		body = body as Player
		body.velocity += impulse
