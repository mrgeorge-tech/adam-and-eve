extends CharacterBody2D

@export var speed: float = 200.0
@onready var anim = $AnimatedSprite2D

var is_attacking = false  # Prevent movement while attacking

func _physics_process(delta):
	var direction = Input.get_axis("move_left", "move_right")

	if is_attacking:
		return  # Prevents movement while attacking

	if direction:
		velocity.x = direction * speed
		if anim.animation != "run":  # Only play if it's not already running
			anim.play("run")
		anim.flip_h = direction < 0  # Flip sprite when moving left
	else:
		velocity.x = 0
		if anim.animation != "idle":  # Only play if it's not already running
			anim.play("idle")

	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")
		await anim.animation_finished  # Wait for the attack animation to finish
		is_attacking = false
