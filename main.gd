extends Node2D

# Scene references
@export var soldier_scene: PackedScene # Assign the Soldier scene in the editor
@export var bullet_scene: PackedScene # Assign the Bullet scene in the editor
@export var bomb_scene: PackedScene # Assign the Bomb scene in the editor
@export var game_over_screen = PackedScene # Assign the Game Over scene in the editor
@export var intro_screen = PackedScene # Assign the Introduction scene in the editor
@export var bg_music : Resource

# Node references
@onready var player = $Player
@onready var soldiers = $Soldiers
@onready var consumables = $Consumables

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	print("Game started!")
	#connect("game_over", self, "_on_game_over")
	setup_game()

func setup_game():
	game_over_screen.visible = false
	player.reset()
	for soldier in soldiers.get_children():
		soldier.reset()
	for consumable in consumables.get_children():
		consumable.reset()
	if bg_music:
		if GlobalAudioManager:
			GlobalAudioManager.play_track(bg_music, 0.5)
		else:
			print("GlobalAudioManager not initialized.")
	else:
		print("bg_music is not set.")

## Spawn a soldier
#func spawn_soldier(position: Vector2) -> void:
	#var soldier = soldier_scene.instantiate()
	#add_child(soldier)
	#soldier.global_position = position
	#print("Soldier spawned at: ", position)
#

func _on_game_over():
	cleanup()
	game_over_screen.visible = true

func cleanup():
	for node in get_tree().get_nodes_in_group("dynamic_objects"):
		node.queue_free()
