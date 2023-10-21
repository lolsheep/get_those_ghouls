class_name Coin
extends Node2D

@onready var collider = $Area2D
@onready var audio_player = $AudioStreamPlayer
var playing := false

func _physics_process(delta):
	var col = collider.get_overlapping_bodies()
	
	if col:
		for c in col:
			if c is Player:
				if !playing:
					playing = true
					audio_player.play()
					Global.score += 5
					await audio_player.finished
					queue_free()
