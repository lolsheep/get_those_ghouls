class_name Player
extends CharacterBody2D

@export var speed = 1500.0
@onready var animator := $animator
@onready var animation_player := $AnimationPlayer
@onready var flashlight := $flashlight
@onready var audio_player := $AudioStreamPlayer
var collided
var invincibility_timer = 1.1
var is_invincible = false
var footstep_timer = 0.4
var last_step_played
var input = Vector2.ZERO
@onready var sounds = [
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 01    [005072].wav"),
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 02    [005073].wav"),
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 03    [005074].wav"),
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 04    [005075].wav"),
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 05    [005076].wav"),
	preload("res://assets/sounds/Classic Old School 8 Bit Retro Game -Single Footstep, Walk - 06    [005077].wav")]

# Not sure if this is the most efficient way of doing this, but I thought it was pretty neat.
func get_player_face() -> String:
	
	# Get normalized direction
	var direction := (get_global_mouse_position() - position)
	# Get angle based on direction
	var angle := PI + atan2(direction.y, direction.x)
	# Using a dict here so that I can simply return 'player_rotation[true]' at the end of the function
	# Only one of these conditions will ever be true at a given time
	var player_rotation := {
		angle > 0 and angle < 1.5 : "up_left",
		angle > 1.5 and angle < 3 : "up_right",
		angle > 3 and angle < 4.7 : "down_right",
		angle > 4.7 : "down_left" 
	}
	return player_rotation[true]
	
func _physics_process(delta : float) -> void:
	
	# Get the most recent player face
	var player_face = get_player_face()
	input = get_input()
	
	# Think I lost my mind here a little bit.
	# Each case will use either the 'up_right' or 'down_right' animation
	# Depending on the result of get_player_facing, it will flip_h to match the appropriate direction
	
	animator.flip_h = "left" in player_face
	
	match player_face:
		"up_left":
			animator.play("up_right")
			flashlight.z_index = -1
			flashlight.position.x = 16
		"up_right":
			animator.play("up_right")
			flashlight.z_index = -1
			flashlight.position.x = 16
		"down_right":
			animator.play("down_right")
			flashlight.z_index = 1
			flashlight.position.x = -17
		"down_left":
			animator.play("down_right")
			flashlight.z_index = 1
			flashlight.position.x = -17
			
	if true in [
		Input.is_action_pressed("down"), 
		Input.is_action_pressed("up"), 
		Input.is_action_pressed("left"), 
		Input.is_action_pressed("right")]:
		if footstep_timer <= 0:
			create_destroy_audio()
			footstep_timer = 0.4
		else:
			footstep_timer -= delta
	else:
		if animator.animation == "up_right":
			animator.play("idle_back")
		else:
			animator.play("idle")
		audio_player.stop()
	if input == Vector2.ZERO:
		if velocity.length() > (600 * delta):
			velocity -= velocity.normalized() * (600 * delta)
		else:
			velocity = Vector2.ZERO
	else:
		velocity += input * speed * delta
		velocity = velocity.limit_length(400)		
		
	collided = move_and_collide(Vector2.ZERO)
	if collided:
		if collided.get_collider():
			velocity.x -= 100
			if not is_invincible:
				Global.health -= 1
				is_invincible = true
	if Global.health < 1:
		Global.health = 5
		get_tree().reload_current_scene()
	if is_invincible:
		do_invincibility(delta)
		
	Global.player_loc = position
	
func get_input():
	
	input.x = int(Input.is_action_pressed("right")) - int(Input.is_action_pressed("left"))
	input.y = int(Input.is_action_pressed("down")) - int(Input.is_action_pressed("up"))
	return input.normalized()
	
func create_destroy_audio():
	var ran_sound = Global.rand_from_array(sounds)
	if ran_sound == last_step_played:
		ran_sound = Global.rand_from_array(sounds)
	var audio = AudioStreamPlayer2D.new()
	audio.stream = ran_sound
	last_step_played = audio.stream
	add_child(audio)
	audio.play()
	await audio.finished
	audio.queue_free()
	
func do_invincibility(delta):
	
	if invincibility_timer > 0:
		if not animation_player.is_playing():
			animation_player.play("hit flash")
		invincibility_timer -= delta
	else:
		animation_player.play("RESET")
		invincibility_timer = 1.1
		is_invincible = false
