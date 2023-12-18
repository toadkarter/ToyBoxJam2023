extends Node2D


@export_group("Debug")
@export var skip_intro: bool = false

@export_group("Scene References")
@export var level_scene: PackedScene
@export var intro_scene: PackedScene
@export var outro_scene: PackedScene

var intro: Node2D
var level: Node2D
var outro: Node2D


func _ready() -> void:
	_play_intro()


func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("quit") and OS.get_name() != "Web":
		get_tree().quit()


func _play_intro() -> void:
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
	var deaths_to_set = level.total_deaths
	if level != null:
		level.queue_free()

	outro = outro_scene.instantiate()
	outro.set_death_count(deaths_to_set)
	add_child(outro)
	
	outro.connect("on_outro_finished", _on_outro_finished)


func _on_outro_finished() -> void:
	if outro != null:
		outro.queue_free()
	_play_intro()
