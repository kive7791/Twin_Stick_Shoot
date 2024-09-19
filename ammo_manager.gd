extends Node

@export var ammo_scene: Resource
@export var number_of_ammo_pickups: int = 5
@export var spawn_area: Rect2 = Rect2(Vector2(494.5, 476.5), Vector2(406.5, 335.5))  # Area where ammo pickups can be spawned, (position(), rectSize())

func _ready():
	spawn_ammo_pickups()

func spawn_ammo_pickups():
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
			print("Failed to instantiate ammo pickup")

func add_ammo_pickup(ammo_pickup):
	get_tree().current_scene.add_child(ammo_pickup)
	print("Spawned ammo at position: ", ammo_pickup.position)
