extends Control

@onready var score := $Score
@onready var timer := $Time
@onready var healthbar := $HeartBox
@onready var health = preload("res://scenes/heart.tscn")
var minutes
var seconds
var time_string

func _ready():
	
	for h in range(Global.health):
		var heart = health.instantiate()
		healthbar.add_child(heart)
#	mute.pressed.connect(_on_mute)
	
func _process(delta):
	
	score.set_text(str(Global.score))
	minutes = Global.time / 60
	seconds = fmod(Global.time, 60)
	time_string = "%02d:%02d" % [minutes, seconds]	
	timer.set_text(time_string)
	
	Global.time+= delta
		

