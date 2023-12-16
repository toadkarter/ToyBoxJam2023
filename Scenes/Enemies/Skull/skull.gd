extends StaticBody2D


@export var projectile_scene: PackedScene
@export var projectile_speed: float =  20.0
@export var num_projectiles_per_emission: int = 3
@export var seconds_between_projectile: float = 0.4
@export var seconds_between_emission: float = 3

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D
@onready var projectile_spawn_location: Node2D = $ProjectileSpawnLocation

var num_projectiles_emitted = 0


func _ready() -> void:
	animations.animation_finished.connect(_on_animation_finished)
	_emit_projectiles()
	pass


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
	projectile.push(20)

