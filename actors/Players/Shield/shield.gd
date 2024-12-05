extends Area2D
class_name Shield

# Code mdoified from video https://www.youtube.com/watch?v=4BDFfumTEV8

# Shield settings
@export var max_hit_points: int # Maximum shield HP
@export var recovery_rate: int # Amount of HP regenerated per second
var current_hit_points: int = 0  # Current shield HP
var is_active = false  # Whether the shield is currently active

# Node References
@onready var sprite = $Sprite2D  # Sprite2D for showing different colors on the shield
@onready var shield_anim = $ShieldAnim  # Shield animation
@onready var recovery_timer = $RecoveryTimer  # Timer for recovery ticks
@onready var health_bar = $HealthBar  # TextureProgressBar for displaying shield health
@onready var collision_shape = $CollisionShape2D  # CollisionShape2D for detecting hits

# Initialization logic
func _ready() -> void:
	current_hit_points = max_hit_points  # Start with full shield HP
	activate()  # Activate the shield at the start of the game
	recovery_timer.start(recovery_timer.wait_time)  # Trigger recovery every second
	update_health_bar()  # Update the bar initially
	print("Shield is ready with HP: ", current_hit_points)

# Activate the shield
func activate() -> void:
	if is_active or current_hit_points <= 0:
		return  # Avoid activation if shield is already active or depleted
	is_active = true
	sprite.show()  # Show the shield
	shield_anim.play("activate")
	sprite.self_modulate = Color(1, 1, 1, 0)
	sprite.scale = Vector2(1, 1)
	print("Shield activated with HP: ", current_hit_points)
	update_health_bar()  # Update the health bar when activating

# Deactivate the shield
func deactivate() -> void:
	is_active = false
	sprite.hide()  # Hide the shield
	shield_anim.play("deactivate")
	print("Shield deactivated")
	update_health_bar()  # Update the health bar when deactivating

# Apply damage to the shield
func take_damage(damage: int, source: Node2D) -> void:
	if not is_active or current_hit_points <= 0:
		return  # Shield is already depleted
	current_hit_points -= damage
	current_hit_points = max(current_hit_points, 0)  # Ensure health doesn't drop below zero
	shield_anim.play("damage")
	update_health_bar()  # Update the progress bar
	print("Shield took damage from ", source, "! Current HP: ", current_hit_points)
	if current_hit_points <= 0:
		deactivate()  # Automatically deactivate if HP is depleted

# Handle damage from colliding bodies
func _on_body_entered(body: Node2D) -> void:
	print("Collision detected with: ", body.name)
	if not is_active:
		return  # Ignore collisions if shield is inactive
	if body.is_in_group("enemies"):
		print("Shield hit by enemy: ", body.name)
		take_damage(10, body)  # Example: Apply 10 damage for enemy hits
	elif body.is_in_group("Projectile"):
		print("Shield hit by projectile: ", body.name)
		take_damage(20, body)  # Example: Apply 20 damage for projectiles
	elif body.is_in_group("Bomb"):
		print("Shield hit by bomb: ", body.name)
		take_damage(30, body)  # Example: Apply 30 damage for bombs

# Recover shield HP over time
func _on_recovery_timer() -> void:
	if current_hit_points < max_hit_points:
		shield_anim.play("activate")
		current_hit_points += recovery_rate
		current_hit_points = min(current_hit_points, max_hit_points)  # Cap at max HP
		update_health_bar()  # Update the progress bar
		print("Shield recovered to: ", current_hit_points)

# Update the TextureProgressBar to reflect current HP
func update_health_bar() -> void:
	if health_bar:
		health_bar.value = current_hit_points
		health_bar.max_value = max_hit_points
		print("HealthBar updated: Value = ", health_bar.value, ", Max = ", health_bar.max_value)

func cleanup() -> void:
	# Stop timers and animations before removal
	if recovery_timer and recovery_timer.is_connected("timeout", Callable(self, "_on_RecoveryTimer_timeout")):
		recovery_timer.disconnect("timeout", Callable(self, "_on_RecoveryTimer_timeout"))
	if shield_anim.is_playing():
		shield_anim.stop()
	print("Shield cleanup complete.")

func reset():
	is_active = true
	sprite.show()  # Show the shield
	shield_anim.play("activate")
	update_health_bar()  # Update the health bar when activating
