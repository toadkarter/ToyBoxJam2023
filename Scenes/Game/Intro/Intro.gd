extends Node2D


signal intro_finished


@export var scroll_speed: float = 50.0
@export var seconds_for_text_on_screen: float = 5.0
@export var seconds_between_text: float = 1.0
@export_multiline var intro_text: Array[String]

@onready var hud: CanvasLayer = $HUD
@onready var story_text: Label = $HUD/StoryText
@onready var hud_animations: AnimationPlayer = $HUDAnimationPlayer
@onready var sky_animations: AnimationPlayer = $SkyAnimationPlayer
@onready var audio_player: AudioStreamPlayer2D = $AudioStreamPlayer2D
@onready var tower: Node2D = $Tower


var scroll_has_started: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		if scroll_has_started:
			_finish_intro()
		else:
			_start_intro()

	if scroll_has_started:
		tower.position.y -= scroll_speed * delta


func _start_intro() -> void:
	hud_animations.play_backwards()
	sky_animations.play("sky_darken")
	audio_player.play()
	scroll_has_started = true

	var title_fade_length: float = hud_animations.get_animation("title_fade").length
	await get_tree().create_timer(title_fade_length).timeout

	_show_text()


func _finish_intro() -> void:
	var seconds_to_wait: float = hud_animations.get_animation("fade_out").length
	hud_animations.play("fade_out")
	await get_tree().create_timer(seconds_to_wait).timeout
	intro_finished.emit()


func _show_text() -> void:
	var fade_seconds = hud_animations.get_animation("story_text_fade_in").length

	for paragraph in intro_text:
		print("We are setting some text")
		story_text.text = paragraph.to_upper()
		hud_animations.play("story_text_fade_in")
		await get_tree().create_timer(seconds_for_text_on_screen).timeout
		hud_animations.play_backwards()
		await get_tree().create_timer(fade_seconds + seconds_between_text).timeout

	_finish_intro()


