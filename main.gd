extends Node2D

# Scene references
@export var soldier_scene: PackedScene # Assign the Soldier scene in the editor
@export var player_scene: PackedScene # Assign the Soldier scene in the editor
@export var game_over_scene: PackedScene # Assign the Game Over scene in the editor
@export var intro_scene: PackedScene # Assign the Introduction scene in the editor
@export var level_scenes: Array[PackedScene] = [
	preload("res://actors/UI/level_1.tscn"),
	preload("res://actors/UI/level_2.tscn")
]
@export var bg_music: Resource # Background music

# Game state
@export var soldiers_per_level: int = 2
var current_level: int = 0              # Tracks the current level index
var current_scene: Node = null          # Tracks the current active scene
var score: int = 0                      # Player's score
var soldiers_remaining: int = 0         # Number of Soldiers alive in the level
var player_health: int = 100            # Player's health
var is_game_over: bool = false          # Game over state

func _ready() -> void:
	print("Game started!")
	if bg_music:
		if GlobalAudioManager:
			GlobalAudioManager.play_track(bg_music, 0.5)
		else:
			print("GlobalAudioManager not initialized.")
	else:
		print("bg_music is not set.")

	_start_intro()

func _start_intro() -> void:
	print("Game _start_intro")
	# Load and display the introduction screen
	# Load the intro scene
	if current_scene:
		current_scene.queue_free()
	current_scene = intro_scene.instantiate()
	add_child(current_scene)
	current_scene.connect("start_game", Callable(self, "_on_start_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))

func _on_start_game() -> void:
	print("Game _on_start_game")
	load_level(0)

func _on_restart_game() -> void:
	print("Game _on_restart_game")
	cleanup()
	current_scene.queue_free() # Remove the intro scene after starting the game
	current_level = 0
	score = 0
	player_health = 100 
	load_level(0)

func _on_quit_game() -> void:
	print("Game _on_quit_game")
	# Quits the game.
	get_tree().quit()

func load_level(level_index: int) -> void:
	print("Game _load_level")

	#if current_level >= level_scenes.size():
		#end_game("YOU WIN!")  # End game if all levels are completed
		#return

	# Free current scene if necessary
	if current_scene:
		current_scene.queue_free()
	current_level = level_index
	soldiers_remaining = soldiers_per_level

	# Load the level scene
	current_scene = level_scenes[level_index].instantiate()
	add_child(current_scene)
	connect_signals_recursively(current_scene)

	# Spawn soldiers
	spawn_soldiers()

func spawn_soldiers():
	for i in range(soldiers_per_level):
		var soldier = soldier_scene.instantiate()
		current_scene.add_child(soldier)

func connect_signals_recursively(node: Node) -> void:
	for child in node.get_children():
		if child.is_in_group("enemies"):
			if not child.is_connected("soldier_killed", Callable(self, "_on_soldier_killed")):
				child.connect("soldier_killed", Callable(self, "_on_soldier_killed"))
				print("Connected soldier_killed signal for: ", child.name)
		elif child.is_in_group("player"):
			if not child.is_connected("player_killed", Callable(self, "_on_player_killed")):
				child.connect("player_killed", Callable(self, "_on_player_killed"))
				print("Connected player_killed signal for: ", child.name)
		connect_signals_recursively(child)

func _on_soldier_killed() -> void:
	print("Game _on_soldier_killed")
	print("Soldier killed! Remaining soldiers: ", soldiers_remaining)
	score += 100
	# Decrease soldier count when one dies
	soldiers_remaining -= 1
	if soldiers_remaining <= 0:
		cleanup()
		if current_level >= level_scenes.size() - 1:
			end_game("YOU WIN!")  # End game if all levels are completed
		else:
			load_level(current_level + 1)

func _on_player_killed() -> void:
	print("Game _on_player_killed")
	end_game("YOU LOST!")

func cleanup() -> void:
	print("Game cleanup")
	for child in get_tree().get_nodes_in_group("dynamic_objects"):
		print("name ", child.name)
		child.queue_free()
	#for level in get_tree().get_nodes_in_group("player"):
		#print("Freeing level:", level.name)
		#level.queue_free()
	for level in get_tree().get_nodes_in_group("enemies"):
		print("Freeing level:", level.name)
		level.queue_free()

func end_game(message: String) -> void:
	print("Game _end_game")
	show_game_over(message)

func show_game_over(message: String) -> void:
	print("Game _show_game_over")
	if current_scene:
		current_scene.queue_free()
	current_scene = game_over_scene.instantiate()
	add_child(current_scene)
	current_scene.set_message(message, score)
	current_scene.connect("restart_game", Callable(self, "_on_restart_game"))
	current_scene.connect("quit_game", Callable(self, "_on_quit_game"))
