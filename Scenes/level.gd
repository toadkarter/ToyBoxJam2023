extends TileMap


const FIREWALL_OFFSET: float = 168.0 


@export var debug_stop_scrolling: bool = false
@export var scroll_speed: float = 50
@export var seconds_between_respawn: float = 1.0
@export var player_scene: PackedScene
@export var checkpoints: Array[Area2D]

@export var death_texts: Array[String]
@export var checkpoint_text: String

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var hud: CanvasLayer = $Camera/HUD
@onready var music_player: AudioStreamPlayer2D = $Camera/MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $Camera/SFXPlayer
@onready var current_checkpoint: Area2D = checkpoints[0]

var player: CharacterBody2D
var total_deaths: int = 0
var scroll_level: bool = true


func _ready() -> void:
	if debug_stop_scrolling:
		scroll_level = false

	music_player.play()
	get_tree().call_group("Debug", "queue_free")
	_init_checkpoints()
	reset_level()

func _process(delta: float) -> void:
	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
	firewall.position.y += -scroll_speed * delta


func _on_player_death() -> void:
	scroll_level = false
	sfx_player.play_death_sfx()
	hud.show_central_notification(death_texts.pick_random(), seconds_between_respawn)
	await get_tree().create_timer(seconds_between_respawn).timeout
	reset_level()

	total_deaths += 1
	hud.set_death_count_label(total_deaths)


func reset_level() -> void:
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
	camera.position.y = current_checkpoint.camera_position
	firewall.position.y = current_checkpoint.camera_position + FIREWALL_OFFSET

	if !debug_stop_scrolling:
		scroll_level = true


func _init_checkpoints() -> void:
	for checkpoint in checkpoints:
		checkpoint.connect("on_player_entered", _on_checkpoint_reached)


func _on_checkpoint_reached(checkpoint: Area2D) -> void:
	if current_checkpoint != checkpoint:
		hud.show_central_notification(checkpoint_text)
		sfx_player.play_checkpoint_sfx()
		current_checkpoint = checkpoint
