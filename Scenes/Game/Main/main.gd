extends Node2D


@export var level_scene: PackedScene


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var level = level_scene.instantiate()
	add_child(level)
