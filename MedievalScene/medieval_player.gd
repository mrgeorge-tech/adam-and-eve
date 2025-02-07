extends CharacterBody2D

@export var speed: float = 200.0
@export var arrow_scene: PackedScene  # Reference to the Arrow.tscn
@onready var anim = $AnimatedSprite2D
@onready var collision_shape = $CollisionShape2D
@export var health: int = 10  # Player starts with 100 HP

var is_attacking = false  # Prevent movement while attacking
var arrow_spawn_frame = 5  # Frame at which the arrow will spawn

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		die()

func die():
	print("Player died!")  # Debugging
	set_physics_process(false)  # Stop player movement
	await anim.animation_finished
	get_tree().call_deferred("change_scene_to_file", "res://MedievalScene/main_menu.tscn")


func _physics_process(_delta):
	var direction = Input.get_axis("move_left", "move_right")

	if is_attacking:
		return  # Prevents movement while attacking

	if direction:
		velocity.x = direction * speed
		if anim.animation != "run":
			anim.play("run")
		anim.flip_h = direction < 0
	else:
		velocity.x = 0
		if anim.animation != "idle":
			anim.play("idle")

	move_and_slide()

func _input(event):
	if event.is_action_pressed("attack") and not is_attacking:
		is_attacking = true
		anim.play("attack")

func _on_animated_sprite_2d_frame_changed() -> void:
	if anim.animation == "attack" and anim.frame == arrow_spawn_frame:
		shoot_arrow()  # Spawn the arrow at the specified frame

	# Check if attack animation has reached its last frame
	var sprite_frames = anim.sprite_frames
	if anim.animation == "attack" and anim.frame == sprite_frames.get_frame_count("attack") - 1:
		is_attacking = false  # Reset attack state

func shoot_arrow():
	if arrow_scene == null:
		print("Error: Arrow scene is not assigned!")
		return

	# Instantiate the arrow
	var arrow = arrow_scene.instantiate()
	get_parent().add_child(arrow)

	# Use CollisionShape2D's global position as the spawn point
	var spawn_position = collision_shape.global_position
	arrow.position = spawn_position

	# Flip the arrow's speed if the player is facing left
	if anim.flip_h:
		arrow.speed *= -1
