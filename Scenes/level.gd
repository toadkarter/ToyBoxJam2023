extends TileMap


const FIREWALL_OFFSET: float = 168.0 


@export var scroll_level: bool = true
@export var scroll_speed: float = 50
@export var seconds_between_respawn: float = 1.0
@export var checkpoint_camera_location: float = 232.0
@export var player_scene: PackedScene
@export var default_checkpoint: Area2D

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var current_checkpoint: Area2D = default_checkpoint

var player: CharacterBody2D


func _ready() -> void:
	reset_level()


func _process(delta: float) -> void:
	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
	firewall.position.y += -scroll_speed * delta


func _on_player_death() -> void:
	scroll_level = false
	await get_tree().create_timer(seconds_between_respawn).timeout
	reset_level()


func reset_level() -> void:
	# TODO: Add UI message
	if player != null:
		player.queue_free()

	_create_player()
	_reset_camera()


func _create_player() -> void:
	player = load(player_scene.resource_path).instantiate()
	add_child(player)
	player.position = current_checkpoint.position
	player.connect("on_death", _on_player_death)
	player.reset_death_state()


func _reset_camera() -> void:
	camera.position.y = checkpoint_camera_location
	firewall.position.y = checkpoint_camera_location + FIREWALL_OFFSET

	scroll_level = true
