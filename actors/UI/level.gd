#extends Node
extends Node2D

# Exported variables for spawning
@export var ammo_scene: PackedScene
@export var health_scene: PackedScene

# Signals
signal soldier_killed
signal player_killed

# Called when the level is ready
func _ready() -> void:
	print("level _ready")
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
