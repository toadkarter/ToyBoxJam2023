extends Area2D


signal on_player_entered(checkpoint: Area2D)

@export var camera_position: float = 232.0


func _ready() -> void:
	connect("body_entered", _on_area_entered)


func _on_area_entered(body: Node2D):
	if body.is_in_group("Player"):
		on_player_entered.emit(self)
