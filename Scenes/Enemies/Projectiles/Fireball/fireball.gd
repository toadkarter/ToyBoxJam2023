extends RigidBody2D


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D


func _ready() -> void:
	animations.play("default")
