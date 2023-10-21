class_name StateMachine
extends Node

@export var state : State

func _ready():
	switch_state(state)

func switch_state(new_state : Node):
	
	if state is State:
		state._exit()
	new_state._enter()
	state = new_state
