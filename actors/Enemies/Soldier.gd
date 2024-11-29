extends EnemiesStateMachine
class_name Enemy

# Health properties
@export var motion_speed: float # Speed at which the soldier moves
@export var max_health: int # Speed at which the soldier moves
@export var collision_damage: int # Damage the soldier inflicts on collision with the player
var health: int = max_health # Maximum health for the soldier
var is_active = true  # Determines if the enemy is active

# Node References
@onready var target = null  # Reference to the player (set dynamically)

func _ready():
	# Try to find the player using a group or direct path
	find_player()
	print("Soldier initialized with health: ", health)

	# Optionally locate the player dynamically
func find_player():
	# Option 1: Locate the player directly
	target = get_tree().get_root().get_node("Main/Player")  # Replace "Game/Player" with the correct path
	if target:
		print("Player found: ", target)
	else:
		print("Player not found at path!")

	# Option 2: Locate via groups (fallback)
	if target == null:
		var players = get_tree().get_nodes_in_group("Player")
		if players.size() > 0:
			target = players[0]
			print("Player found via group: ", target)
		else:
			print("No Player found in group.")

func _physics_process(_delta):
	if not is_active or !is_instance_valid(target):
		return  # Stop enemy logic if inactive or target is invalid

	# Move toward the player
	var direction = (target.global_position - global_position).normalized()
	velocity = direction * motion_speed
	move_and_slide()  # Placeholder for movement logic

# Called when the player or projectile collides with the enemy
func _on_body_entered(body: Node2D) -> void:
	#print(body.name + " Test Soldier")
	#print("Object Name: " + body.name + ", Groups: " + str(body.get_groups()))
	if body.is_in_group("player"):  # Ensure it's the player
		emit_signal("soldier_hit", body)  # Emit signal with the player reference0

# Function to handle taking damage
func take_damage(damage: int) -> void:
	#emit_signal("receive_damage", damage)
	health -= damage
	print("Enemy took damage! Remaining health:", health)
	
	# Destroy the enemy if health is <= 0
	if health <= 0:
		#ScoreManager.add_score(100)
		die()

# Function to handle enemy destruction
func die() -> void:
	print("Enemy destroyed!")
	is_active = false  # Mark as inactive
	queue_free()  # Remove this enemy from the scene	

func deactivate():
	# Deactivate the soldier (e.g., when the player dies)
	is_active = false
	velocity = Vector2.ZERO  # Stop the enemy immediately
	print("Enemy deactivated!")

func reset():
	health = max_health
