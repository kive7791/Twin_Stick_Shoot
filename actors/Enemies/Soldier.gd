extends Area2D

# Health properties
@export var max_health: int = 5
var current_health: int = max_health

# Signal to notify when the enemy takes damage
signal soldier_hit(body)

# Called when the player or projectile collides with the enemy
func _on_body_entered(body: Node2D) -> void:
	#print(body.name + " Test Soldier")
	#print("Object Name: " + body.name + ", Groups: " + str(body.get_groups()))
	if body.is_in_group("player"):  # Ensure it's the player
		emit_signal("soldier_hit", body)  # Emit signal with the player reference0

# Function to handle taking damage
func take_damage(damage: int) -> void:
	#emit_signal("receive_damage", damage)
	current_health -= damage
	print("Enemy took damage! Remaining health:", current_health)
	
	# Destroy the enemy if health is <= 0
	if current_health <= 0:
		die()

# Function to handle enemy destruction
func die() -> void:
	queue_free()  # Remove this enemy from the scene
	print("Enemy destroyed!")
