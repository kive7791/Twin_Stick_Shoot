extends Area2D

@export var ammo_amount: int # Amount of ammo to add when picked up

func _ready() -> void:
	add_to_group("consumables")

func _on_body_entered(body: Node2D) -> void:
	print("ammo _on_body_entered")
	if body.is_in_group("player"):  # Ensure the body is the player
		body.add_ammo(ammo_amount)  # Call a method on the player to add ammo
		queue_free()  # Remove the ammo pickup from the scene
