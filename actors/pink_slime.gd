extends Area2D

signal slime_hit(body)

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):  # Ensure it's the player
		emit_signal("slime_hit", body)  # Emit signal with the player reference
