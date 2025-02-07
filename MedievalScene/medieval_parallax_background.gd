extends ParallaxBackground

@export var scroll_speed: float = 100.0  # Base speed
@onready var player = get_node("../MedievalScene/Player")  # Reference the player

func _process(delta):
	if player:  # Make sure player exists
		scroll_offset.x -= player.velocity.x * delta * 0.5  # Moves with player
