extends TextureProgressBar

# Based on the max_sp
@export var percentage_per_sp: float = 0.0
# Bar speed
@export var speed: float = 0.0

#@onready var animationPlayer: AnimationPlayer = get_node("AnimationPlayer")

func _ready() -> void:
	# Set the minimum value
	set_min(0)
	# Set the maximum value
	set_max(5)
	# Set initial value
	set_value(5)  # Set this to your desired starting value
	# Show the progress indicator
	hide()
	#animationPlayer.play("update")

func _enter_tree() -> void:
	hide()  # Initially hide the progress bar

func _on_shield_sp_changed(new_value: float) -> void:
	# Decrease health of the sheild and update the progress bar
	# and clamp the value to ensure it doesn't go below the minimum
	set_value(clamp(new_value, get_min(), get_max()))
	if (0 < get_value() && get_value() < 100):
		show()
	else:
		hide()

func _on_shield_recovering_speed_changed(new_speed: float) -> void:
	#print('2')
	speed = new_speed

func _on_shield_max_sp_changed(new_max: int) -> void:
	#print('3')
	percentage_per_sp = round(100.0 / new_max)
