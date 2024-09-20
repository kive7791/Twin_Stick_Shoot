extends Area2D

var velocity: Vector2 = Vector2(0,0)
@onready var time_to_live = $TimeToLive  # Timer node for projectile lifespan

func _ready():
	#debug for projectile not showing - the pathway was wrong 
	var sprite = $MainSprite
	sprite.visible = true  # Ensure the sprite is visible
	print("Projectile ready at: ", position)
	
	# Connect the collision signals
	$CollisionShape2D.set_deferred("disabled", false)
	connect("area_entered", Callable(self, "_on_area_entered"))
	connect("body_entered", Callable(self, "_on_body_entered"))
	
	# Start the lifespan timer if it's not already started
	if time_to_live:
		time_to_live.start()

func fire(forward: Vector2, speed: float):
	velocity = forward * speed
	look_at(position + forward)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	position += velocity * delta


func _on_time_to_live_timeout():
	queue_free()

func _on_area_entered(area):
	# Handle collision
	if area.is_in_group("walls"):
		explode()

func _on_body_entered(body):
	# Handles collision
	if body.is_in_group("walls"):
		explode()

func explode():
	# Add visual or sound effects here
	print("Projectile hit!")
	
	# Remove the projectile
	queue_free()
