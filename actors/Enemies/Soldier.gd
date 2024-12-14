extends CharacterBody2D

# Health properties
@export var motion_speed: float # Speed at which the soldier moves
@export var max_health: int # Maximum health of the soldier
@export var collision_damage: int # Damage the soldier inflicts on collision with the player
var health: int = max_health # Current health of the soldier
var is_active = true  # Determines if the enemy is active

# Node References
@onready var target: Node2D = null  # Reference to the player (set dynamically)
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
#@onready var agent: NavigationAgent2D = $NavigationAgent2D # Path finding agent

# Signals
signal soldier_killed

func _ready():
	sprite.play("Idle")
	print("Soldier _ready")
	add_to_group("enemies")  # Ensure this node is part of the "enemies" group
	find_player()
	print("Soldier initialized with health: ", health)

func find_player():
	print("Soldier find_player")
	# Option 1: Locate the player directly
	target = get_tree().get_root().get_node("level/Player")  # Replace "Game/Player" with the correct path
	if target:
		print("Player found: ", target.name)
	else:
		print("Player not found at path!")

	# Option 2: Locate via groups (fallback)
	if target == null:
		var players = get_tree().get_nodes_in_group("player")
		if players.size() > 0:
			target = players[0]
			print("Player found via group: ", target.name)
		else:
			print("No Player found in group.")

func _physics_process(_delta):
	if not is_active or !is_instance_valid(target):
		return  # Stop enemy logic if inactive or target is invalid
	# Behavior for "Collector" soldier
	if name == "Collector":
		var target_pack = find_nearest_pack()
		if target_pack:
			var direction = (target_pack.global_position - global_position).normalized()
			velocity = direction * motion_speed
			if velocity.length() > 0:
				sprite.play("Walk")
			else:
				sprite.play("Idle")
			move_and_slide()
			
			# Check for collision with the collectible
			if global_position.distance_to(target_pack.global_position) < 10:  # Adjust range as needed
				target_pack.queue_free()  # Destroy the collectible
				print("Collector destroyed a collectible!")
		else:
			sprite.play("Idle")
	else:
		# Default behavior for other soldiers (e.g., move toward the player)
		if is_instance_valid(target):
			var direction = (target.global_position - global_position).normalized()
			velocity = direction * motion_speed
			if velocity.length() > 0:
				sprite.play("Walk")
			else:
				sprite.play("Idle")
			move_and_slide()

# Find the nearest health or ammo pack
func find_nearest_pack() -> Node:
	var nearest_pack = null
	var nearest_distance = INF

	# Check health packs
	for pack in get_tree().get_nodes_in_group("dynamic_objects"):
		if pack and pack.is_inside_tree():
			var distance = global_position.distance_to(pack.global_position)
			print("distance ", distance)
			if distance < nearest_distance:
				nearest_pack = pack
				nearest_distance = distance

	return nearest_pack

# Function to handle taking damage
func take_damage(damage: int) -> void:
	print("Soldier take_damage")
	health -= damage
	print("Enemy took damage! Remaining health:", health)
	
	# Destroy the enemy if health is <= 0
	if health <= 0 and is_active:
		is_active = false
		sprite.play("Dealth")
		emit_signal("soldier_killed")
		queue_free()

func _on_detection_range_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		swing_attack(body)

# Swing attack logic
func swing_attack(player: Node2D):
	if not is_active:
		return
	print("Soldier swings at the player: ", player.name)
	sprite.play("Attack")  # Play the attack animation
	#if player.has_method("take_damage"):
		#player.take_damage(collision_damage)  # Apply damage to the player
