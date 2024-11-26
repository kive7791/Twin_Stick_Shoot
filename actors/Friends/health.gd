extends Area2D

@export var health_amount: int = 2  # Amount of health to add when picked up

# DO NOT FORGET TO ADD THIS TO SIGNALS!!!!
func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure the body is the player
		body.add_health(health_amount)  # Call a method on the player to add ammo
		queue_free()  # Remove the ammo pickup from the scene
