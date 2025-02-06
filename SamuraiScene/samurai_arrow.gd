extends Area2D

@export var speed: float = 500.0
@export var damage: int = 5

func _process(delta):
	position.x += speed * delta  # Move arrow forward

func _on_body_entered(body):
	if body.has_method("take_damage"):  # Check if enemy has health system
		body.take_damage(damage)
	queue_free()  # Destroy the arrow after hitting something
