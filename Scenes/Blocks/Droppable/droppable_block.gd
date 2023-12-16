extends RigidBody2D


@export var seconds_before_falling = 0.5
@onready var hitbox: Area2D = $Hitbox


func _ready() -> void:
	hitbox.connect("body_entered", _on_hitbox_triggered)


func _on_hitbox_triggered(body: Node) -> void:
	if body.is_in_group("Player"):
		await get_tree().create_timer(seconds_before_falling).timeout
		gravity_scale = 1.0



