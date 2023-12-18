extends Area2D


signal on_player_entered


@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var hitbox: CollisionShape2D = $Hitbox
@onready var fade_in_length: float = animations.get_animation("fade_in").length


func _ready() -> void:
	connect("body_entered", _on_body_entered)


func play_spawn_sequence() -> void:
	animations.play("fade_in")
	await get_tree().create_timer(fade_in_length).timeout
	hitbox.disabled = false


func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("Player"):
		on_player_entered.emit()


	
