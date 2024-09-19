extends Area2D

@export var ammo_amount: int = 5  # Amount of ammo to add when picked up

# DO NOT FORGET TO ADD THIS TO SIGNALS!!!!
func _on_body_entered(body):
	if body.is_in_group("player"):  # Ensure the body is the player
		body.add_ammo(ammo_amount)  # Call a method on the player to add ammo
		queue_free()  # Remove the ammo pickup from the scene
