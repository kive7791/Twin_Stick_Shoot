extends Area2D
# Code mdoified from video https://www.youtube.com/watch?v=4BDFfumTEV8

@export var max_sp: int = 5
signal max_sp_changed(new_max)
signal sp_changed(new_value)
signal receive_damage(amount: int)

var _sp: int = max_sp  # Private variable for shield points (SP)

var recovering: bool = false
@export var recovering_speed: float = 1.5
signal recovering_speed_changed(new_speed)

@onready var sprite: Sprite2D = get_node("Sprite2D")
@onready var collisionShape: CollisionShape2D = get_node("CollisionShape2D")
@onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")
@onready var recoverTimer: Timer = get_node("RecoveryTimer")

# Getter and setter for 'sp' variable
var sp: int:
	get:
		return _sp
	set(value):
		_sp = clamp(value, 0, max_sp)
		emit_signal("sp_changed", _sp)

func _ready() -> void:
	collisionShape.disabled = false
	sprite.self_modulate = Color(1, 1, 1, 0)
	sprite.scale = Vector2(1, 1)

	get_parent().connect("receive_damage", Callable(self, "_on_parent_receive_damage"))

	emit_signal("max_sp_changed", max_sp)
	emit_signal("recovering_speed_changed", recovering_speed)

func take_damage(dam: int) -> void:
	emit_signal("receive_damage", dam)
	recovering = false
	sp -= dam  # Use the property now
	if sp == 0:
		animationPlayer.play("deactivate")
	else:
		animationPlayer.play("damage")
	recoverTimer.start()

func _on_recovery_timer_timeout() -> void:
	if sp == 0:
		animationPlayer.play("activate")

	recovering = true
	while recovering:
		sp += 1  # Use the property now
		if sp == max_sp:
			recovering = false
		await get_tree().create_timer(recovering_speed).timeout

func _on_parent_receive_damage(dam: int) -> void:
	print("Shield received damage: ", dam)
	recovering = false
	recoverTimer.start()
