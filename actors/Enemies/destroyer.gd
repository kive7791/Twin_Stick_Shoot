extends EnemiesStateMachine
class_name Destroyer

# Health properties
@export var motion_speed: float # Speed at which the soldier moves
@export var max_health: int # Maximum health of the soldier
@export var collision_damage: int # Damage the soldier inflicts on collision with the player
var health: int = max_health # Current health of the soldier
var is_active = true  # Determines if the enemy is active

# Node References
@onready var target: Node2D = null  # Reference to the player (set dynamically)

# Signals
signal soldier_killed

func _ready():
	print("Soldier _ready")
	add_to_group("enemies")  # Ensure this node is part of the "enemies" group
	find_player()
	print("Soldier initialized with health: ", health)

func find_player():
	print("Soldier find_player")
	# Option 1: Locate the player directly
	target = get_tree().get_root().get_node("level/Consumables")  # Replace "Game/Player" with the correct path
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

	# Move toward the player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * motion_speed
	move_and_slide()  # Placeholder for movement logic

# Function to handle taking damage
func take_damage(damage: int) -> void:
	print("Soldier take_damage")
	health -= damage
	print("Enemy took damage! Remaining health:", health)
	
	# Destroy the enemy if health is <= 0
	if health <= 0:
		emit_signal("soldier_killed")
		queue_free()
