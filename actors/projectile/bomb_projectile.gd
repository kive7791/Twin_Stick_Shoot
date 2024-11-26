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
	if $ExplosionArea.has_overlapping_areas():
		explode_area($ExplosionArea.get_overlapping_areas())
	elif $ExplosionArea.has_overlapping_bodies():
		explode_body($ExplosionArea.has_overlapping_bodies())

func _on_area_entered(area):
	print(area.name + " Test1 Bomb")
	print("Object Name: " + area.name + ", Groups: " + str(area.get_groups()))
	# Handle collision
	if area.is_in_group("enemies"):  # If it collides with an enemy
		print("Area Bomb hit! " + area.name)
		explode_area(area)

func _on_body_entered(body):
	print(body.name + " Test2 Bomb")
	print("Object Name: " + body.name + ", Groups: " + str(body.get_groups()))
	if body.is_in_group("walls"):
		print("Body Bomb hit! " + body.name)
		explode_body(body)

func explode_area(area):
	# Stop emitting particles on explosion
	if trail_particles:
		trail_particles.emitting = false

	# This is where the damage is delt 
	# or effects to everything in the explosion area
	# Damage everything within the explosion radius
	print("Damaged:", area.name)
	if area.is_in_group("enemies"):
		print("Damaged:", area.name)
		area.take_damage(explosion_damage) # Call the enemy's damage method
	
	# Remove the bomb after explosion
	queue_free()

func explode_body(body):
	# Stop emitting particles on explosion
	if trail_particles:
		trail_particles.emitting = false
	
	# This is where the damage is delt 
	# or effects to everything in the explosion area
	# Damage everything within the explosion radius
	print("Damaged:", body.name)
	if body.is_in_group("enemies"):
		print("Damaged:", body.name)
		body.take_damage(explosion_damage) # Call the enemy's damage method
	
	# Remove the bomb after explosion
	queue_free()
