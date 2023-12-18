extends Node2D

signal on_outro_finished

@export var seconds_before_player_animation = 4.0
@export var seconds_before_score = 2.0

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var sfx_player: AudioStreamPlayer2D = $SFXPlayer
@onready var score_num_text: Label = $HUD/ScoreNumText
@onready var player_disappears_length = animations.get_animation("player_disappears").length
@onready var show_score_length = animations.get_animation("show_score").length

var outro_animations_finished: bool = false
var is_returning_to_title: bool = false

func _ready() -> void:
	await get_tree().create_timer(seconds_before_player_animation).timeout
	animations.play("player_disappears")
	await get_tree().create_timer(player_disappears_length + seconds_before_score).timeout
	animations.play("show_score")
	await get_tree().create_timer(show_score_length).timeout
	outro_animations_finished = true

func _process(_delta: float) -> void:
	if !outro_animations_finished:
		return

	if Input.is_action_just_pressed("jump"):
		if is_returning_to_title:
			return
		is_returning_to_title = true
		animations.play_backwards()
		await get_tree().create_timer(show_score_length).timeout
		on_outro_finished.emit()


func set_death_count(num_deaths_to_set: int):
	score_num_text.text = "%d" % num_deaths_to_set

func play_death_sound() -> void:
	sfx_player.play()
