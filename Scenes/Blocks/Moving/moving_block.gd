extends StaticBody2D


@export var offset: Vector2 = Vector2(-50, 0)
@export var duration: float = 4
@export var is_moving: bool = false

@onready var body: AnimatableBody2D = $Blocks
@onready var original_position: Vector2 = position


func _ready() -> void:
	if is_moving:
		var tween = create_tween().set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.set_loops().set_parallel(false)
		tween.tween_property(body, "position", offset, duration / 2)
		tween.tween_property(body, "position", Vector2.ZERO, duration / 2)


func reset_state() -> void:
	position = original_position
