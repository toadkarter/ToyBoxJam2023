extends Node2D


@export var player_scene: PackedScene 


func _ready() -> void:
	spawn_player()


func _process(delta: float) -> void:
	pass


func spawn_player() -> void:
	var player = player_scene.instantiate()
	add_child(player)
	print(player)
	print(position)
	print(player.position)
	player.position = position
