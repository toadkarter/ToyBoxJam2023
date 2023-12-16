extends TileMap


@export var scroll_level: bool = true
@export var scroll_speed: float = 5

@onready var camera: Camera2D = $Camera

func _process(delta: float) -> void:
	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
