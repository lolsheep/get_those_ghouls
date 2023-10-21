class_name EnemyChase
extends State

@export var enemy : Enemy
@export var sprite_group : CanvasGroup
var shake = [-1, 1]

signal enemy_hit

func _ready() -> void:
	set_physics_process(false)
	
func _enter() -> void:

	set_physics_process(true)
	
func _update(delta) -> void:
		pass
		
func _exit() -> void:
	set_physics_process(false)

func _physics_process(delta):
	
	var direction = enemy.position.direction_to(Global.player_loc)
	enemy.position += direction * enemy.speed * delta
	
	if enemy.is_hit:
		enemy_hit.emit()
