extends Node2D

@export var speed: float = 2.0

@onready var original_rotation: float = rotation 


func _ready() -> void:
	pass # Replace with function body.


func _process(delta: float) -> void:
	rotation += speed * delta


func reset_state() -> void:
	rotation = original_rotation
