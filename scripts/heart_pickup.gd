class_name Heart
extends Node2D

@onready var collider = $Area2D
@onready var audio_player = $AudioStreamPlayer2D

var playing = false
func _physics_process(delta):
	
	var col = collider.get_overlapping_bodies()
	if col:
		for c in col:
			if c is Player:
				if !playing:
					playing = true
					audio_player.play()
					visible = false
					if Global.health < 5:
						Global.health += 1
					audio_player.finished.connect(queue_free)
				
