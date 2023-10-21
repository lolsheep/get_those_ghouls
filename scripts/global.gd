extends Node

var player_loc
var game_started = false
var game_paused
var time = 0.0

var score = 0
var coin_timer = 3
var max_ghosts = 1
var health = 5

func rand_from_array(arr):
	return arr[randi() % arr.size()]
