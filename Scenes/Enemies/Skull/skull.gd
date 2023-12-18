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
	_init_projectiles()


func _emit_projectiles() -> void:
	animations.play("attack")
	for i in range(num_projectiles_per_emission):
		_spawn_projectile()
		await _run_timer(seconds_between_projectile)


func _on_animation_finished() -> void:
	await _run_timer(seconds_between_emission)
	_emit_projectiles()


func _spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.position = projectile_spawn_location.position
	projectile.push(projectile_speed)


func _init_projectiles() -> void:
	await _run_timer(seconds_before_starting_emissions)
	_emit_projectiles()


func reset_state() -> void:
	animations.stop()
	for node in get_children():
		var timer: Timer = node as Timer
		if !is_instance_valid(timer) or timer.is_queued_for_deletion():
			continue
		timer.paused = true

	_init_projectiles()


func _run_timer(seconds: float) -> void:
	var timer: Timer = Timer.new()
	add_child(timer)
	timer.wait_time = seconds
	timer.one_shot = true
	timer.start()
	await timer.timeout
	timer.queue_free()
