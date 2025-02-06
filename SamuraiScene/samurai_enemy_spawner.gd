extends Node2D

@export var enemy_scene: PackedScene  # Reference to Enemy.tscn
@export var boss_scene: PackedScene  # Reference to Boss.tscn
@export var spawn_interval: float = 2.0  # Time between spawns

var enemies_killed = 0  # Track how many enemies have been killed
var can_spawn = true  # Control spawning behavior

func _ready():
	print("Spawner ready!")  # Debug message
	call_deferred("spawn_enemy")  # Use call_deferred to start spawning after setup

func spawn_enemy():
	if not can_spawn:
		print("Enemy spawn blocked!")
		return

	print("Attempting to spawn an enemy...")  # Debug message

	var enemy = enemy_scene.instantiate()
	if enemy == null:
		print("Enemy scene is not valid!")
		return

	print("Spawning enemy...")  # Debug message
	enemy.position = global_position

	# Add enemy safely after scene setup
	get_parent().call_deferred("add_child", enemy)

	# Connect the "tree_exited" signal to track enemy deaths
	enemy.connect("tree_exited", Callable(self, "_on_enemy_killed"))

func _on_enemy_killed():
	enemies_killed += 1
	print("Enemy killed! Total killed:", enemies_killed)  # Debug message

	if enemies_killed < 3:
		call_deferred("spawn_enemy")  # Delay spawning the next enemy
	elif enemies_killed == 3:
		call_deferred("spawn_boss")  # Delay boss spawning

func spawn_boss():
	can_spawn = false  # Stop regular enemy spawns
	print("Spawning boss...")  # Debug message

	var boss = boss_scene.instantiate()
	boss.position = global_position

	# Add boss safely after scene setup
	get_parent().call_deferred("add_child", boss)
