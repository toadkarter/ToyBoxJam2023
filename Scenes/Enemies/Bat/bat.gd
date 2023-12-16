extends StaticBody2D


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	animations.play("default")