extends MarginContainer
@onready var play = $Main_menu/VBoxContainer/MenuBar/play
@onready var quit = $Main_menu/VBoxContainer/MenuBar/quit
@onready var audio_player = $AudioStreamPlayer
@onready var menu_noice = preload("res://assets/sounds/switch_007.ogg")

func _ready():
	play.pressed.connect(_on_play)
	quit.pressed.connect(_on_quit)


func _process(delta):
	
	if true in [quit.is_hovered(), play.is_hovered()] and  !audio_player.playing:
		
		audio_player.set_stream(menu_noice)
		audio_player.play()
	

func _on_play():
	
	get_tree().paused = false
	Global.game_started = true
	queue_free()

func _on_quit():
	get_tree().quit()
