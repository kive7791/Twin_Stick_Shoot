extends CharacterBody2D

@export var projectile_scene: Resource
@export var bomb_projectile_scene: Resource
@export var move_speed: float = 200.0
@export var max_ammo: int = 10

var current_ammo: int = 5
var is_shield_active: bool = true
var health: int = 10 

@onready var ammo_label = $"../UI/AmmoLable"
@onready var game_mech_label = $"../UI/GameMech"
@onready var pink_slime: Area2D = $"../BadSlime"


func _ready():
	add_to_group("player")
	update_ammo_display()
	pink_slime.connect("slime_hit", Callable(self, "_on_slime_hit")) 

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

func take_damage(dam: int) -> void:
	#Implement this later 
	print("Damage to player! Remaining health", health)
	health -= dam
	#if health <= 0:
		#Game_Over()

func _on_slime_hit(body):
	if has_shield():
		var shield = $Shield
		shield.take_damage(1)
	else:
		take_damage(1) 

func has_shield() -> bool:
	return is_shield_active
