extends StaticBody2D


@export var projectile_scene: PackedScene
@onready var projectile_spawn_location: Node2D = $ProjectileSpawnLocation


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	_spawn_projectile()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _spawn_projectile() -> void:
	var projectile = projectile_scene.instantiate()
	add_child(projectile)
	projectile.position = projectile_spawn_location.position
