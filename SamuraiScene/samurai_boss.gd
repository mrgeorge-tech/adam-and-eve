extends CharacterBody2D

@export var speed: float = 200.0
@export var health: int = 2000
@export var damage: int = 40  # Damage dealt to the player
@onready var anim = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D

var is_attacking = false
var player = null  # Reference to the player

func _ready():
	anim.play("walk")  # Start with the walk animation

func _physics_process(delta):
	if player and is_instance_valid(player):  # Ensure player exists
		if global_position.distance_to(player.global_position) < 50:  # Attack range
			if not is_attacking:
				attack_player()
		else:
			move_towards_player(delta)
	else:
		move_towards_player(delta)

func move_towards_player(delta):
	if is_attacking:
		return  # Stop moving if attacking

	# Move towards the player
	var direction = (player.global_position - global_position).normalized() if player else Vector2(-1, 0)
	velocity.x = direction.x * speed
	move_and_slide()

	# Ensure walking animation plays only if not already playing
	if anim.animation != "walk":
		anim.play("walk")

func attack_player():
	is_attacking = true
	velocity.x = 0  # Stop moving during the attack loop
	anim.play("attack")

	while player and is_instance_valid(player):
	# Play attack animation and deal damage
		anim.play("attack")
		await anim.animation_finished  # Wait for the attack animation to finish

	# Apply damage to the player
		if player and is_instance_valid(player):
			player.take_damage(damage)
			print("Enemy attacked the player!")  # Debugging

	is_attacking = false  # Exit the attack loop when the player leaves range

func take_damage(amount: int):
	health -= amount
	print("Enemy took damage. Current health:", health)  # Debugging
	if health <= 0:
		die()  # Call die() when health reaches 0

func die():
	print("Enemy died!")  # Debugging
	anim.play("death")
	set_physics_process(false)  # Stop enemy movement
	await anim.animation_finished
	queue_free()  # Remove the enemy after death animation

func _on_area_2d_body_entered(body) -> void:
	if body.name == "Player":
		player = body  # Store player reference
		print("Player entered attack range!")  # Debugging
		print("Entered body name:", body.name)
		attack_player()

func _on_area_2d_body_exited(body) -> void:
	if body.name == "Player":
		player = null  # Remove reference when player leaves range
		print("Player exited attack range!")  # Debugging
