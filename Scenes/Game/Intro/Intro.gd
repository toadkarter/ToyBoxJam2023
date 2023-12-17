extends Node2D


@onready var hud: CanvasLayer = $HUD
@onready var animations: AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animations.play("press_start_fade_in_and_out")


func _process(delta: float) -> void:
	if Input.is_action_just_pressed("jump"):
		animations.stop()
