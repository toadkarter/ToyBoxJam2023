extends TileMap


const FIREWALL_OFFSET: float = 168.0 


@export var scroll_level: bool = true
@export var scroll_speed: float = 5
@export var seconds_between_respawn: float = 1.0
@export var checkpoint_camera_location: float = 232.0
@export var player_scene: PackedScene

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var checkpoint: Node2D = $Checkpoint
# @onready var player: CharacterBody2D = $Player # TODO: Access this dynamically

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


func reset_level() -> void:
	if player != null:
		player.queue_free()

	_create_player()
	_reset_camera()


func _create_player() -> void:
	player = load(player_scene.resource_path).instantiate()
	add_child(player)
	player.position = checkpoint.position
	player.connect("on_death", _on_player_death)
	player.reset_death_state()


func _reset_camera() -> void:
	camera.position.y = checkpoint_camera_location
	firewall.position.y = checkpoint_camera_location + FIREWALL_OFFSET

	scroll_level = true
