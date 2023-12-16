extends StaticBody2D

@export var speed: float = 40.0
@export var distance: float = 200.0

@onready var animations: AnimatedSprite2D = $AnimatedSprite2D

var forward: bool = true

func _ready() -> void:
	animations.play("default")


func _process(delta: float) -> void:
	distance -= delta
	print(distance)
	position.x += speed * delta
