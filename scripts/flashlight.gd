class_name Flashlight
extends Node2D

@onready var collider := $collider
@onready var player : Player

var collided
var ghost_names = []

func _physics_process(delta):
	
	look_at(get_global_mouse_position())
	for g in ghost_names.size():
		if ghost_names[g]:
			
			var wr = weakref(ghost_names[g])
			if !wr.get_ref():
				ghost_names.remove_at(0)
				break
				
			if ghost_names[g] not in collided:
				if ghost_names[g] != null:
					ghost_names[g].is_hit = false


	_check_collision()

func _check_collision():
	
	collided = collider.get_overlapping_bodies()
	if collided:
		for c in collided:
			if c is Enemy:
				if not c.is_hit:
					c.is_hit = true
					if c not in ghost_names:
						ghost_names.append(c)
				
					
				
				


