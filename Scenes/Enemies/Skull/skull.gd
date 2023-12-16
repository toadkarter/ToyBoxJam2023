extends StaticBody2D


@export var projectile_scene: PackedScene
@export var projectile_speed: float =  20.0
@export var num_projectiles_per_emission: int = 3
@export var seconds_between_projectile: float = 0.4
@export var seconds_between_emission: float = 3
@export var seconds_before_starting_emissions: float = 0.0

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var projectile_spawn_location: Node2D = $ProjectileSpawnLocation


func _ready() -> void:
	animations.animation_finished.connect(_on_animation_finished)
	await get_tree().create_timer(seconds_before_starting_emissions).timeout

	_emit_projectiles()


func _emit_projectiles() -> void:
	animations.play("attack")
	for i in range(num_projectiles_per_emission):
		_spawn_projectile()
		await get_tree().create_timer(seconds_between_projectile).timeout


func _on_animation_finished() -> void:
	await get_tree().create_timer(seconds_between_emission).timeout
	_emit_projectiles()


func _spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.position = projectile_spawn_location.position
	projectile.push(projectile_speed)

