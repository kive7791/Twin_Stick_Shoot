extends CharacterBody2D
class_name Player

# Player properties
@export var bullet_scene: PackedScene # Assign the Bullet scene in the editor
@export var bomb_scene: PackedScene  # Assign the Bomb scene in the editor
@export var gunshot1_sfx : Resource
@export var gunshot2_sfx : Resource

# Player stats
@export var motion_speed: float # Speed at which the player moves
@export var collision_damage: int # Damage the player inflicts or takes on collision
@export var max_health: int # should be 100
@export var max_ammo: int # Maximum ammunition for bombs
var health: int = 0 # Player's current health
var ammo: int = 0 # Player's current ammunition

# Node references
@onready var ammo_label = $FollowCam/UI/AmmoLable
@onready var health_label = $FollowCam/UI/HealthLable
@onready var game_mech_label = $FollowCam/UI/GameMech
@onready var shield = $Shield  # Reference to the Shield node
@onready var collision_area = $CollisionArea  # Area2D for detecting overlapping enemies/projectiles

func _ready():
	health = max_health
	ammo = max_ammo
	add_to_group("player")
	update_ammo_display()
	update_health_display()
	print("Player is ready with health: ", health, " and ammo: ", ammo)

func _input(event):
	if (event is InputEventMouseButton):
		# Left click: Fire regular projectile
		if (event.button_index == 1 and event.is_pressed()):
			shoot_bullet()
		# Right click: Fire bomb projectile (AOE)
		if (event.button_index == 2 and event.is_pressed()):
			shoot_bomb()

# Movement logic
func _physics_process(_delta: float) -> void:
	# Update velocity for 2D movement
	velocity.x = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")
	velocity.y = Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	velocity = velocity.normalized() * motion_speed  # Normalize for diagonal movement
	move_and_slide() # Apply movement
	update_facing() # Update facing directio n based on mouse or movement

# Update facing direction
func update_facing():
	# Example: Use mouse position to determine the look direction
	var facing_position = get_global_mouse_position() # Position the player is looking at
	look_at(facing_position)  # Rotate the player to face the mouse position
	#look_at(get_viewport().get_mouse_position())

func add_ammo(amount: int):
	ammo = min(max_ammo, ammo + amount)
	update_ammo_display()

func update_ammo_display():
	ammo_label.text = "Ammo: " + str(ammo) + " / " + str(max_ammo)

func heal(amount: int):
	health = min(max_health, health + amount)
	update_health_display()

func update_health_display():
	health_label.text = "Health: " + str(health) + " / " + str(max_health)

func handle_player_win():
	print("Player has won!")
	#var game_over = GameOverScreen.instantiate()
	#add_child(game_over)
	#game_over.set_title(true)
	#get_tree().paused = true ##Stops all game processing - freezes background
	queue_free()

func handle_player_lost():
	print("Player has died!")

	# Remove all enemies from the scene
	var enemies = get_tree().get_nodes_in_group("enemies")
	for enemy in enemies:
		print("Removing enemy ", enemy.name)
		enemy.queue_free()

	# Disconnect signals to prevent errors
	if collision_area.is_connected("body_entered", Callable(self, "on_collision")):
		print("disconnecting collision_area ", "on_collision")
		collision_area.disconnect("body_entered", Callable(self, "on_collision"))

	# Remove the shield
	if shield:
		print("Removing shield...")
		shield.cleanup()
		shield.queue_free()  # Free the Shield scene

	## If the character dies
	#var game_over = GameOverScreen.instantiate()
	#add_child(game_over)
	#game_over.set_title(false)
	#get_tree().paused = true

	# Show the Game Over UI
	#gameOver.show_game_over()
	#get_tree().change_scene_to_file("res://actors/UI/game_over.tscn")

	#queue_free()

# Handle collisions with soldiers using Area2D's signal
func on_collision(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		print("Player collided with enemy: ", body.name)
		handle_collision_with_enemy(body)

# Collision logic for enemy
func handle_collision_with_enemy(enemy: Node2D) -> void:
	if shield.is_active:
		shield.take_damage(collision_damage, enemy)
		print("Shield absorbed enemy hit: ", enemy.name)
		return
	take_damage(collision_damage)
	if enemy.has_method("take_damage"):
		enemy.take_damage(collision_damage)
		print("Enemy ", enemy.name, " took damage!")

func take_damage(damage: int) -> void: 
	health = clamp(health - damage, 0, max_health)
	print("Damage to player! Remaining health", health)
	update_health_display()

	if not shield.is_active:
		shield.activate()

	if health <= 0:
		handle_player_lost()

func shoot_bullet():
	# Check if player has ammo
	if ammo <= 0:
		print("No ammo left!")
		return

	var bullet = bullet_scene.instantiate() # Create a new bullet instance
	get_parent().add_child(bullet)
	var direction = Vector2.from_angle(rotation)
	bullet.fire(direction)
	bullet.position = $ProjectileRefPoint.global_position
	GlobalAudioManager.play_SFX(gunshot1_sfx, 0.4)

	ammo -= 1  # Decrease ammo count
	update_ammo_display()
	print("Bullet shot! Ammo left: ", ammo)

# Shoot the bomb in the direction the player is looking
func shoot_bomb() -> void:
	# Check if player has ammo
	if ammo <= 0:
		print("No ammo left!")
		return

	# Spawn and configure the bomb
	var bomb = bomb_scene.instantiate()  # Create a new bomb instance
	get_parent().add_child(bomb)
	var throw_direction = (get_global_mouse_position() - global_position).normalized()
	print("Bomb thrown in direction: ", throw_direction)
	bomb.fire(throw_direction)  # Use the bomb's fire function
	bomb.position = $ProjectileRefPoint.global_position  # Spawn the bomb at the player's position
	game_mech_label.visible = false
	GlobalAudioManager.play_SFX(gunshot2_sfx, 0.4)

	ammo -= 1 # Reduce ammo
	update_ammo_display()
	print("Bomb thrown! Ammo left: ", ammo)

func reset():
	health = max_health
	ammo = max_ammo
	shield.reset()
	update_ammo_display()
	update_health_display()
	
