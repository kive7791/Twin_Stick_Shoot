extends Area2D
class_name Bullet

# Bomb settings
@export var bullet_damage: int # Damage dealt by the bullet
@export var motion_speed: float # Speed at which the bomb moves
var velocity: Vector2 = Vector2.ZERO # Current velocity of the bullet

# Node references
@onready var time_to_live = $TimeToLive  # Reference to the Timer node

func _ready() -> void:
	# Start the lifespan timer if it's not already started
	time_to_live.start(time_to_live.wait_time)
	#debug for projectile not showing - the pathway was wrong 
	var sprite = $MainSprite
	sprite.visible = true  # Ensure the sprite is visible
	print("Gun shot is active and moving")

# Fires the projectile in the specified direction with the given speed
func fire(direction: Vector2) -> void:
	velocity = direction.normalized() * motion_speed
	#look_at(position + direction) # Rotate projectile to face its direction
	rotation = direction.angle()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	position += velocity * delta # Update position

# Handles collisions with bodies
func _on_body_entered(body: Node2D) -> void:
	print("Gun shot _on_body_entered")
	handle_collision(body)

# Generic collision handling
func handle_collision(target: Node2D) -> void:
	print("Gun shot handle_collision")
	print("Object Name: " + target.name + ", Groups: " + str(target.get_groups()))
	if target.is_in_group("enemies"):
		print("take_damage ", bullet_damage, " to ", target.name)
		target.take_damage(bullet_damage)  # Apply damage to enemies
		queue_free()  # Remove the projectile
	elif target.is_in_group("walls"):
		queue_free()  # Remove the projectile upon hitting walls

# Removes the projectile when its lifespan ends
func _on_timeout() -> void:
	print("Gun shot timed out!")
	queue_free()
