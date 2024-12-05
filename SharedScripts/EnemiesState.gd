extends Node
class_name EnemiesState

var main_sprite : Sprite2D
var body : EnemiesStateMachine

# Variables
var current_state: EnemiesState = null
var states: Dictionary = {}

# Initialize the state machine and its states
func _ready() -> void:
	# Assume children nodes are states; initialize them
	for child in get_children():
		if child is EnemiesState:
			states[child.name] = child
			child.initialize(self)  # Pass a reference to the state machine

	# Start in the "Idle" state by default
	if "Idle" in states:
		transition_to(states["Idle"])

# Transition to a new state
func transition_to(new_state: EnemiesState) -> void:
	if current_state:
		current_state.exit()  # Exit the current state
	current_state = new_state
	current_state.enter()  # Enter the new state

# Process the current state every frame
func _process(delta: float) -> void:
	if current_state:
		current_state.process_state(delta)

# Optional debug helper to print the current state
func get_current_state_name() -> String:
	if current_state != null:
		return current_state.name
	return "None"

func initialize(_state_machine_ref: Node2D):
	pass

func on_enter_state():
	pass
	
func on_exit_state():
	pass

func process_state(_delta: float):
	pass

func process_input(_event: InputEvent):
	pass
