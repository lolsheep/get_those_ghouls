extends Node2D

var ghosts = [preload("res://scenes/walker.tscn")]
var health = preload("res://scenes/heart_pickup.tscn")
var coin = preload("res://scenes/coin.tscn")

var spawn_timer = randi_range(2,4)
var ghost_nodes = []
var ghost_limit = 1
var ghost_increase_time = 30.0
var coin_chance = 0.2
var coin_timer = 3

var heart_chance = 0.1
var heart_timer = 5

func _ready():
	
	get_tree().paused = true
	
func rand_location():
	var loc = Vector2.ZERO
	loc.x = Global.rand_from_array([randi_range(-100,0), randi_range(2000, 2100)])
	loc.y = Global.rand_from_array([randi_range(-100,0), randi_range(1100, 1200)])
	return loc
	
func spawn_ghost():
	
	for i in range(ghost_limit):
		var ghost = Global.rand_from_array(ghosts).instantiate()
		ghost.position = rand_location()
		add_child(ghost)
		ghost_nodes.append(ghost)

func spawn_heart():
	var loc = Vector2(randi_range(100, 1910), randi_range(100,1070))
	var h = health.instantiate()
	h.global_position = to_local(loc)
	add_child(h)
	
func spawn_coin():
	
	var loc = Vector2(randi_range(100, 1910), randi_range(100,1070))
	var c = coin.instantiate()
	c.global_position = to_local(loc)
	add_child(c)
				
func _physics_process(delta):
	
	if get_tree().paused:
		return
		
	if coin_timer <= 0:
		coin_timer = 3
		if randf_range(0,1) < coin_chance:
			spawn_coin()
			
	if spawn_timer <= 0:
		spawn_ghost()
		spawn_timer = randi_range(2,4)	
	
	if heart_timer <= 0:
		heart_timer = 5
		if randf_range(0,1) < heart_chance and Global.health < 5:
			spawn_heart()
			
	if Global.time > ghost_increase_time:
		ghost_increase_time += 31.0
		ghost_limit += 1
		
	coin_timer -= delta
	spawn_timer -= delta
	heart_timer -= delta
	
	
	pass
