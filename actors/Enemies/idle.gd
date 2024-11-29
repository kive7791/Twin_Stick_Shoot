extends EnemiesState

var detect_range: Area2D
var chasing_state: EnemiesState
var state_machine  # Reference to the parent state machine

# Initialize detection range and chasing state
func initialize(state_machine_ref: Node) -> void:
	state_machine = state_machine_ref  # Set the parent state machine
	print("Idle ", "initialize")
	detect_range = body.get_node("DetectionRange")
	if not detect_range:
		print("Error: DetectionRange not found!")
		return

	chasing_state = get_parent().get_node("Chasing")
	if not chasing_state:
		print("Error: Chasing state not found!")
		return

	print(detect_range.name)
	print(chasing_state.name)

# Check if a player is within range and switch to Chasing state
# Process logic for the idle state
func process_state(_delta: float) -> void:
	if not detect_range:
		print("Error: DetectionRange not initialized.")
		return

	for bdy in detect_range.get_overlapping_bodies():
		if bdy.is_in_group("Player"):  # Ensure the player is in the "Player" group
			print("Player detected! Switching to Chase state.")
			state_machine.transition_to(chasing_state)
			return  # Exit after switching state

# Called when the state is entered
func enter() -> void:
	print("Idle State: Entered.")

# Called when the state is exited
func exit() -> void:
	print("Idle State: Exited.")
