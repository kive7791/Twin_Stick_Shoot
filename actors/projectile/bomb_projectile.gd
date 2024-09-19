extends Area2D

@export var initial_speed: float = 500.0  # The initial speed of the bomb
@export var explosion_radius: float = 50.0  # Radius of the explosion
@export var explosion_damage: float = 100.0 # Damage dealt to objects in the area
@export var explosion_delay: float = 1.0    # Time before the bomb explodes
@export var custom_gravity: float = 500.0  # gravity for bomb

var velocity: Vector2 = Vector2.ZERO
var exploded: bool = false
@onready var trail_particles = $TrailParticles

func _ready():
	$TimeToLive.wait_time = explosion_delay
	$TimeToLive.start()

func fire(forward: Vector2):
	velocity = forward * initial_speed
	trail_particles.emitting = true

func _physics_process(delta):
	#arcing the bomb - y axis
	velocity.y += custom_gravity * delta
	#velocity
	position += velocity * delta
	#rotate bomb to face correct direction
	look_at(position + velocity)

func _on_Timer_timeout():
	explode()

func explode():
	# Stop emitting particles on explosion
	if trail_particles:
		trail_particles.emitting = false
	if exploded:
		return
	exploded = true
	
	# Where I would add visual/sound effects for explosion
	$ExplosionArea.set_monitoring(true)
	
	# This is where the damage is delt 
	# or effects to everything in the explosion area
	for body in $ExplosionArea.get_overlapping_bodies():
		print("Damaged:", body.name)
	
	# Remove the bomb after explosion
	queue_free()
