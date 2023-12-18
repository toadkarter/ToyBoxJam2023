extends Node2D

@export var speed: float = 2.0

@onready var original_rotation: float = rotation 



# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	rotation += speed * delta


func reset_state() -> void:
	rotation = original_rotation
