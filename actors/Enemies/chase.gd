extends EnemiesState

# Variables
@export var chase_speed: float = 500.0  # Speed at which the enemy chases
var target: Node2D  # The target to chase (e.g., the player)
var state_machine  # Reference to the state machine

# Initialize the state
func initialize(state_machine_ref: Node) -> void:
	state_machine = state_machine_ref  # Set the parent state machine
	print("Chase State: Initialized.")

# Process the chase logic
func process_state(_delta: float) -> void:
	if not target:
		print("No target to chase.")
		return

	# Move toward the target
	var direction = (target.global_position - body.global_position).normalized()
	body.velocity = direction * chase_speed
	body.move_and_slide()

	# Optional: Check if the target has moved out of range
	if not is_target_in_range():
		print("Target out of range, switching to Idle state.")
		var idle_state = state_machine.states.get("Idle")
		if idle_state:
			state_machine.transition_to(idle_state)

# Enter the state
func enter() -> void:
	print("Chase State: Entered.")
	# Ensure we have a valid target when entering this state
	target = find_target()

# Exit the state
func exit() -> void:
	print("Chase State: Exited.")
	body.velocity = Vector2.ZERO  # Stop movement when exiting

# Helper to find the target (e.g., the player)
func find_target() -> Node2D:
	# Create the parameters object for the query
	var query_params = PhysicsPointQueryParameters2D.new()
	query_params.position = self.global_position  # Use the current global position
	query_params.collide_with_areas = true  # Ensure it checks for areas
	query_params.collide_with_bodies = true  # Ensure it checks for physics bodies

	# Perform the query
	var space_state = body.get_world_2d().direct_space_state
	var results = space_state.intersect_point(query_params)

 # Loop through results to find a valid target
	for result in results:
		var collider = result["collider"]
		if collider and collider.is_in_group("Player"):
			return collider as Node2D  # Return the player if found

	return null  # Return null if no valid target is found

# Check if the target is within a certain range
func is_target_in_range() -> bool:
	if not target:
		return false
	return body.global_position.distance_to(target.global_position) <= 1000.0  # Example range
