extends StaticBody2D

@export var offset: Vector2 = Vector2(0, -50)
@export var duration: float = 3.0

@onready var animations: AnimatedSprite2D = $AnimatableBody2D/AnimatedSprite2D
@onready var body: AnimatableBody2D = $AnimatableBody2D


func _ready() -> void:
	animations.play("default")
	_start_movement()


func _start_movement() -> void:
	var tween = get_tree().create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
	tween.set_loops().set_parallel(false)
	tween.tween_property(body, "position", offset, duration / 2)
	tween.tween_property(body, "position", Vector2.ZERO, duration / 2)
