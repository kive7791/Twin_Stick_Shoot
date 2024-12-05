# Our state machine class will extend CharacterBody2D so that
# We can use it on our root scene element for enemies.
extends CharacterBody2D
class_name EnemiesStateMachine

@export var initial_state : EnemiesState
@onready var current_state : EnemiesState = initial_state

var all_states : Array[EnemiesState] = []

# Handle user input and pass it to the current state
func _input(event: InputEvent):
	current_state.process_input(event)

# Initialize states during the ready phase
func _ready():
	for child in $States.get_children():
		if (child is EnemiesState):
			all_states.append(child)
			child.change_state.connect(on_change_state)
			child.body = self
			child.initialize(self)
		else:
			push_warning("Child " + child.name + " is not a state for " + self.name)
	
	initialize()

func initialize():
	pass
	
func _physics_process(_delta: float):
	pass
	#current_state.process_state(delta)

func on_change_state(next_state: EnemiesState):
	current_state.on_exit_state()
	current_state = next_state
	current_state.on_enter_state()
