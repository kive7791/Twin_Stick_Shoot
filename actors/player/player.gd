extends CharacterBody2D

@export var projectile_scene: Resource
@export var bomb_projectile_scene: Resource
@export var move_speed: float = 200.0
@export var max_ammo: int = 10
@export var max_health: int = 10

var current_ammo: int = 10
var current_health: int = 1
var is_shield_active: bool = true 

@onready var ammo_label = $FollowCam/UI/AmmoLable
@onready var health_label = $FollowCam/UI/HealthLable
@onready var game_mech_label = $FollowCam/UI/GameMech
@onready var soldier: Area2D = $"../Soldier"

const GameOverScreen = preload("res://actors/UI/game_over.tscn")

func _ready():
	add_to_group("player")
	update_ammo_display()
	update_health_display()
	soldier.connect("soldier_hit", Callable(self, "_on_soldier_hit")) 

func _input(event):
	if (event is InputEventMouseButton):
		# Left click: Fire regular projectile
		if (event.button_index == 1 and event.is_pressed()):
			if current_ammo > 0:
				shoot_projectile()
				current_ammo -= 1  # Decrease ammo count
				update_ammo_display()
			else:
				print("No ammo left!")

		# Right click: Fire bomb projectile (AOE)
		if (event.button_index == 2 and event.is_pressed()):
			if current_ammo > 0:
				shoot_bomb_projectile()
				current_ammo -= 1  # Decrease ammo count
				update_ammo_display()
				game_mech_label.visible = false
			else:
				print("No ammo left!")

func shoot_projectile():
	var new_projectile = projectile_scene.instantiate()
	get_parent().add_child(new_projectile)
	var projectile_forward = Vector2.from_angle(rotation)
	new_projectile.fire(projectile_forward, 1000.0)
	new_projectile.position = $ProjectileRefPoint.global_position

func shoot_bomb_projectile():
	var bomb_projectile = bomb_projectile_scene.instantiate()
	get_parent().add_child(bomb_projectile)
	var bomb_projectile_forward = Vector2(cos(rotation), sin(rotation))
	bomb_projectile.fire(bomb_projectile_forward)
	bomb_projectile.position = $ProjectileRefPoint.global_position

func _physics_process(delta):
	look_at(get_viewport().get_mouse_position())
	
	velocity = Input.get_vector("move_left", \
		"move_right", \
		"move_up", \
		"move_down") * move_speed
	move_and_slide()
	

func add_ammo(amount: int):
	current_ammo = min(max_ammo, current_ammo + amount)
	update_ammo_display()

func update_ammo_display():
	ammo_label.text = "Ammo: " + str(current_ammo) + " / " + str(max_ammo)

func add_health(amount: int):
	current_health = min(max_health, current_health + amount)
	update_health_display()

func take_damage(damage: int) -> void: 
	current_health = min(max_health, current_health - damage)
	print("Damage to player! Remaining health", current_health)
	update_health_display()
	
	if current_health <= 0:
		handle_player_win()

func update_health_display():
	health_label.text = "Health: " + str(current_health) + " / " + str(max_health)

func _on_soldier_hit(body):
	var shield = $Shield
	if (shield.shield_active() == true):
		shield.take_damage(2)
	else:
		take_damage(2)

func handle_player_win():
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	game_over.set_title(true)
	get_tree().paused = true ##Stops all game processing - freezes background

func handle_player_lost():
	# If the character dies
	var game_over = GameOverScreen.instantiate()
	add_child(game_over)
	game_over.set_title(false)
	get_tree().paused = true
