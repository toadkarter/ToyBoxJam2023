extends Node2D


@export var level_scene: PackedScene
@export var intro_scene: PackedScene

var intro: Node2D
var level: Node2D


func _ready() -> void:
	intro = intro_scene.instantiate()
	add_child(intro)

	intro.connect("intro_finished", _on_intro_finished)


func _on_intro_finished() -> void:
	intro.queue_free()
	level = level_scene.instantiate()
	add_child(level)
