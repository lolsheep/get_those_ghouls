class_name EnemyDie
extends State

@export var enemy : Enemy
@export var sprite_group : CanvasGroup
var shake = [-1, 1]

func _ready() -> void:
	set_physics_process(false)
	
func _enter() -> void:

	set_physics_process(true)
	
func _update(delta) -> void:
		pass
		
func _exit() -> void:
	set_physics_process(false)

func _physics_process(delta):
	
	pass
