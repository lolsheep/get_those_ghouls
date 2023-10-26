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
	
	var direction = enemy.position.direction_to(enemy.to_local(Global.player_loc))
	enemy.velocity += direction * enemy.speed * delta
	enemy.velocity = enemy.velocity.limit_length(200)
	if enemy.is_hit:
		enemy_hit.emit()
