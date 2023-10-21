extends Control

@onready var resume = $Resume
@onready var quit = $Quit
@onready var pause_music = $mute_music

# Called when the node the scene tree for the first time.
func _ready():
	visible = false
	resume.pressed.connect(_on_resume)
	quit.pressed.connect(_on_quit)
	pause_music.toggled.connect(_on_mute)
	pass

func _process(delta):
	
	if Input.is_action_just_pressed("pause"):
		if Global.game_started:
			get_tree().paused = !get_tree().paused
			visible = !visible
			Global.game_paused = !Global.game_paused

func _on_resume():
	get_tree().paused = false
	visible = false
	Global.game_paused = false
	
func _on_quit():
	get_tree().quit()

func _on_mute(t):
	
	var master_sound = AudioServer.get_bus_index("Master")
	var muted = AudioServer.is_bus_mute(master_sound)
	AudioServer.set_bus_mute(master_sound, !muted)
