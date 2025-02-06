extends ParallaxBackground

@export var scroll_speed: float = 100.0  # Speed of background movement

func _process(delta):
	scroll_offset.x -= scroll_speed * delta  # Moves background left
