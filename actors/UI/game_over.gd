extends CanvasLayer

@onready var title = %Win_Lose

func set_title(win: bool):
	if win:
		title.text = "YOU WIN!"
		title.modulate = Color.DARK_GREEN
	else:
		title.text = "YOU LOSE!"
		title.modulate = Color.DARK_RED

func _on_restart_pressed() -> void:
	get_tree().paused = false
	get_tree().change_scene_to_file("res://main.tscn")

func _on_quit_pressed() -> void:
	get_tree().quit()
