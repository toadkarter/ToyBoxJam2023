extends Node2D


@export_group("Debug")
@export var skip_intro: bool = false

@export_group("Scene References")
@export var level_scene: PackedScene
@export var intro_scene: PackedScene

var intro: Node2D
var level: Node2D


func _ready() -> void:
	if !skip_intro:
		intro = intro_scene.instantiate()
		add_child(intro)
		intro.connect("intro_finished", _on_intro_finished)
	else:
		_on_intro_finished()


func _on_intro_finished() -> void:
	if intro != null:
		intro.queue_free()
	level = level_scene.instantiate()
	add_child(level)
	level.connect("on_level_finished", _on_level_finished)


func _on_level_finished() -> void:
	print("Level is finished")