class_name Enemy
extends CharacterBody2D

@onready var collider := $CollisionShape2D
@onready var state_machine := $StateMachine
@onready var enemy_chase := $StateMachine/EnemyChase
@onready var enemy_hit := $StateMachine/EnemyHit
@onready var sprite := $CanvasGroup/sprite


@onready var hit_sounds := [
preload("res://assets/sounds/creature1.ogg"),
preload("res://assets/sounds/creature2.ogg"),
preload("res://assets/sounds/creature3.ogg"),
preload("res://assets/sounds/creature4.ogg"),
preload("res://assets/sounds/creature5.ogg")]

@onready var death_sounds := [
	preload("res://assets/sounds/ghost_die1.wav"),
	preload("res://assets/sounds/ghost_die2.wav")
]
var frames
var is_hit : bool
var death_timer
var speed = 400
var health

func hit():
	
	var sound_manager = AudioStreamPlayer.new()

	add_child(sound_manager)
	
	if !sound_manager.playing:
		sound_manager.bus = "enemy_effects"
		sound_manager.set_stream(Global.rand_from_array(hit_sounds))
		sound_manager.play()
		await sound_manager.finished
		sound_manager.queue_free()
		
func die(delta):
	
	var sound_manager = AudioStreamPlayer.new()
	
	add_child(sound_manager)
	
	if !sound_manager.playing:
		
		sound_manager.bus = "enemy_effects"
		sound_manager.set_stream(Global.rand_from_array(death_sounds))
		sound_manager.play()
		sprite.play("die")
		await sound_manager.finished
		Global.score += 1
		
	if sprite.animation_finished:
		queue_free()
		
	
func _ready():
	
	health = scale.x * randi_range(70,100)
	enemy_chase.enemy_hit.connect(state_machine.switch_state.bind(enemy_hit))
	enemy_hit.enemy_chasing.connect(state_machine.switch_state.bind(enemy_chase))

func _physics_process(delta):
	
	state_machine.state._update(delta)
	
	sprite.flip_h = Global.player_loc.x > position.x
#	if health <= 0:
#		position.y -= -1 * 300 * delta
#	set_shader_parameter("line_thickness", 2)
	move_and_slide()

	
