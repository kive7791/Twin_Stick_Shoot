extends Control
class_name GameOver

@onready var title = %Win_Lose

func set_title(win: bool):
	title.text = "YOU WIN!" if win else "YOU LOSE!"
	title.modulate = Color.DARK_GREEN if win else Color.DARK_RED

func show_game_over():
	visible = true  # Show the Game Over UI
	print("Game Over UI displayed.")

func _on_restart_pressed() -> void:
	print("restart_pressed...")
	# Reload the gameplay scene
	get_tree().reload_current_scene()
	#get_tree().paused = false
	#get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
