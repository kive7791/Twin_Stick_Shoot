extends Node
class_name Consumables

# Consumable properties
@export var ammo_scene: PackedScene # Ammo pack scene
@export var health_scene: PackedScene # Health pack scene
@export var number_of_ammo_pickups: int = 2
@export var number_of_health_pickups: int = 5

# Node references
@onready var spawn_area_shape = $Spawn_Area/CollisionShape2D

var spawn_area: Rect2 #= Rect2(Vector2(494.5, 476.5), Vector2(406.5, 335.5))  

func _ready():
	print("pack_manager _ready")

	# Get the shape dimensions
	var shape = spawn_area_shape.shape
	if shape is RectangleShape2D:
		var extents = shape.extents
		var top_left = spawn_area_shape.global_position - extents
		var size = extents * 2
		spawn_area = Rect2(top_left, size)

	spawn_ammo_pickups()
	spawn_health_pickups()

func spawn_ammo_pickups():
	print("pack_manager spawn_ammo_pickups")
	for i in range(number_of_ammo_pickups):
		var ammo_pickup = ammo_scene.instantiate()
		if ammo_pickup:
			var random_position = Vector2(
				randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
				randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
			)
			ammo_pickup.position = random_position
			call_deferred("add_ammo_pickup", ammo_pickup)  # Use call_deferred to add the ammo pickup - couldn't do it right away
		else:
			print("Failed to instantiate ammo or health pickup")

func spawn_health_pickups():
	print("pack_manager spawn_health_pickups")
	for i in range(number_of_health_pickups):
		var health_pickup = health_scene.instantiate()
		if health_pickup:
			var random_position = Vector2(
				randf_range(spawn_area.position.x, spawn_area.position.x + spawn_area.size.x),
				randf_range(spawn_area.position.y, spawn_area.position.y + spawn_area.size.y)
			)
			health_pickup.position = random_position
			call_deferred("add_health_pickup", health_pickup)
		else:
			print("Failed to instantiate ammo or health pickup")

func add_ammo_pickup(ammo_pickup):
	print("pack_manager add_ammo_pickup")
	get_tree().current_scene.add_child(ammo_pickup)
	#print("Spawned ammo at position: ", ammo_pickup.position)

func add_health_pickup(health_pickup):
	print("pack_manager add_health_pickup")
	get_tree().current_scene.add_child(health_pickup)
	#print("Spawned health at position: ", health_pickup.position)

func reset() -> void:
	print("pack_manager reset")
	spawn_ammo_pickups()
	spawn_health_pickups()
