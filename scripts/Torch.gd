class_name Torch
extends Node

@export var state : LightState
@export var arm : Arm

var damage
var scene

enum LightState {
	LOW,
	MED,
	HIGH,
	SUPER
}

var Lights : Dictionary = {
	LightState.LOW : {
		"damage" : [1,2],
		"scene" : load("res://scenes/flashlight/torch_low.tscn")
	},
	LightState.MED : {
		"damage" : [3,4],
		"scene" : load("res://scenes/flashlight/torch_med.tscn")
	}
}

func _ready():
	
	var current_light = Lights[state]
	set_properties(current_light)
	#change_light_scene()
	
func return_damage_amount(d) -> int:
	return randi_range(d[0], d[1])
	
func set_properties(light : Dictionary) -> void:
	
	scene = light["scene"].instantiate()
	damage = return_damage_amount(light["damage"])
	change_light_scene()
	
func change_light_scene():
	
	for c in arm.get_children():
		if c.name == "light":
			arm.remove_child(c)
			c.queue_free()

	arm.add_child.call_deferred(scene)
