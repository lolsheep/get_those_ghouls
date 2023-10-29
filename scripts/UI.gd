extends Control

@onready var score := $Score
@onready var timer := $Time
@onready var healthbar := $HeartBox
@onready var health = preload("res://scenes/heart.tscn")
var minutes
var seconds
var time_string
var temp_health

func _ready():
	temp_health = Global.health
	for h in range(Global.health-1):
		var heart = health.instantiate()
		healthbar.add_child(heart)
#	mute.pressed.connect(_on_mute)
	
func _process(delta):
	
	if Global.health < temp_health:
		var child = healthbar.get_child(0)
		healthbar.remove_child(child)
		child.queue_free()
		temp_health = Global.health
		
	elif Global.health > temp_health:
		var heart = health.instantiate()
		healthbar.add_child(heart)
		temp_health = Global.health
		
	score.set_text(str(Global.score))
	minutes = Global.time / 60
	seconds = fmod(Global.time, 60)
	time_string = "%02d:%02d" % [minutes, seconds]	
	timer.set_text(time_string)
	
	Global.time+= delta
		

