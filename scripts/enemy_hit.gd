class_name EnemyHit
extends State

@export var enemy : Enemy
@export var sprite_group : CanvasGroup

var shake = [-1, 1]
var current = 0
var death_timer
var shader
var shader_thickness
var has_died = false
var die_direction = Global.rand_from_array(shake)

signal enemy_chasing

func _ready() -> void:
	set_physics_process(false)

func _enter() -> void:
	
	enemy.hit()
	shader = enemy.sprite.material
	shader_thickness = 0.01
	set_physics_process(true)
	
func _update(delta) -> void:
	
	shader.set_shader_parameter("width", shader_thickness)
	enemy.health -= randi_range(1,2)
	
	if enemy.health <= 1 and not has_died:
		has_died = true
		enemy.die(delta)
		
	shader_thickness += 0.05
		
func _exit() -> void:
	
	enemy.sprite.play("walk")
	shader_thickness = 0
	shader.set_shader_parameter("width", shader_thickness)
	set_physics_process(false)

func _physics_process(delta):

	if !enemy.is_hit and enemy.health > 0:
		enemy_chasing.emit()
	
	if not has_died:
		var direction = enemy.position.direction_to(Global.player_loc)
		enemy.velocity += direction * (enemy.speed-delta) * delta
		enemy.velocity = enemy.velocity.limit_length(200)
		
