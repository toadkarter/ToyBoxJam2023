extends StaticBody2D


@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

var speed: float = 0.0


func _ready() -> void:
	animations.play("default")
	

func _process(delta: float) -> void:
	position.x += speed * delta


func push(speed_to_set: float):
	speed = speed_to_set


func reset_state():
	queue_free()
