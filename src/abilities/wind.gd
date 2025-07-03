extends Ability

@export var impulse_strenght:float = 5
@onready var wind_particles: GPUParticles2D = $wind_particles

func _ready() -> void:
	super()
	wind_particles.emitting = true

func _handle_ability():
	body_entered.connect(_body_entered)
	await get_tree().create_timer(0.3).timeout
	body_entered.disconnect(_body_entered)
	await get_tree().create_timer(1.0).timeout
	call_deferred("_check_and_free")

func _body_entered(body:Node2D):
	if body is not PhysicsBody2D:return
	var impulse:Vector2 = (body.global_position - global_position) * impulse_strenght
	
	if body is Platform:
		body = body as Platform
		body.apply_impulse(impulse)
	#if body is Player: #todo
		#body = body as Player
		#body.velocity += impulse
