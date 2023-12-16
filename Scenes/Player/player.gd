extends CharacterBody2D


@export var speed: float = 300.0
@export var jump_velocity: float = -400.0

@onready var animations: AnimatedSprite2D = $Animations

var gravity: int = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity

	_handle_move_input()

	_handle_sprite_flip()
	_handle_animations()

	move_and_slide()


func _handle_move_input() -> void:
	var direction := Input.get_axis("move_left", "move_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)


func _handle_sprite_flip() -> void:
	if velocity.x > 0 and animations.flip_h:
		animations.flip_h = false
	elif velocity.x < 0 and !animations.flip_h:
		animations.flip_h = true


func _handle_animations() -> void:
	if !is_on_floor():
		animations.play("jump")
	elif velocity.x == 0:
		animations.play("default")
	else:
		animations.play("run")
