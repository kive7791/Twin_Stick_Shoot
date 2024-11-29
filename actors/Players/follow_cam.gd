extends Camera2D

@export var tilelayer: TileMapLayer
@export var tileSize: Vector2i = Vector2i(16, 16)  # Assuming your tiles are 16x16 pixels

func _ready() -> void:
	var mapRect = tilelayer.get_used_rect()
	var worldPositionInPixels = mapRect.position * tileSize  # Calculate the top-left corner in pixels
	var worldSizeInPixels = mapRect.size * tileSize  # Calculate the size in pixels

	# Boundaries
	limit_left = worldPositionInPixels.x
	limit_top = worldPositionInPixels.y
	limit_right = worldPositionInPixels.x + worldSizeInPixels.x
	limit_bottom = worldPositionInPixels.y + worldSizeInPixels.y

	# Debug print to check the limits
	#print("Left: ", limit_left, " Right: ", limit_right)
	#print("Top: ", limit_top, " Bottom: ", limit_bottom)
