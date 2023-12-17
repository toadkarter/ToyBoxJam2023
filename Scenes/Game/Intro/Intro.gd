extends Node2D


signal intro_finished


@export var scroll_speed: float = 50.0

@onready var hud: CanvasLayer = $HUD
@onready var hud_animations: AnimationPlayer = $HUDAnimationPlayer
@onready var sky_animations: AnimationPlayer = $SkyAnimationPlayer
@onready var tower: Node2D = $Tower


var scroll_has_started: bool = false


func _ready() -> void:
	pass


func _process(delta: float) -> void:
	if Input.is_anything_pressed():
		if scroll_has_started:
			intro_finished.emit()
		else:
			_start_intro()

	if scroll_has_started:
		tower.position.y -= scroll_speed * delta


func _start_intro() -> void:
	hud_animations.play_backwards()
	sky_animations.play("sky_darken")
	scroll_has_started = true
