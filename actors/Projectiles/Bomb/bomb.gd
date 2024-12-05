extends Area2D
class_name Bomb

# Bomb settings
@export var explosion_damage: int # Damage dealt to objects in the area
@export var motion_speed: float # Speed at which the bomb moves
var velocity: Vector2 = Vector2.ZERO # Initial velocity of the bomb

# Node references
@onready var time_to_live = $TimeToLive  # Reference to the Timer node
@onready var trail_particles = $TrailParticles  # Reference to the TrailParticle node for the bomb
@onready var explosion_area = $ExplosionArea # Reference to the ExplosionArea node

#Sound FSX
@export var boom_sfx : Resource

# Called when the bomb is added to the scene
func _ready() -> void:
	time_to_live.start(time_to_live.wait_time)  # Start the auto-explosion timer
	trail_particles.emitting = true  # Start emitting the trail particles
	print("bomb is active and moving")

# Fires the bomb in the specified direction with the given speed
func fire(direction: Vector2) -> void:
	velocity = direction.normalized() * motion_speed  # Set the bomb's velocity
	print("Bomb initialized with velocity: ", velocity)

# Handles physics calculations each frame
func _physics_process(delta: float) -> void:
	# arcing the bomb - y axis
	velocity.y += gravity * delta
	# move the bomb in a straight line
	position += velocity * delta

# Handle collisions with other objects
func _on_body_entered(body : Node2D) -> void:
	# Handle collision with wall
	if body.is_in_group("walls"):
		print("Bomb hit a wall!")
		explode()
	# Handle collision with enemy
	elif body.is_in_group("enemies"):
		print("Bomb hit a soldier!")
		explode()

# Explode the bomb and damage enemies in the explosion radius
func explode() -> void:
	trail_particles.emitting = false  # Stop emitting particles
	print("Bomb exploded!")
	GlobalAudioManager.play_SFX(boom_sfx, 0.4)
	var bodies = explosion_area.get_overlapping_bodies()
	for body in bodies:
		if body.is_in_group("enemies"):
			body.take_damage(explosion_damage) # Call the enemy's damage method
	queue_free()  # Remove the bomb after the explosion

# Handle auto explosion so that the bomb doesn't exist indefinitely
func _on_timeout() -> void:
	print("Bomb timed out!")
	explode()
