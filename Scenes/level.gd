extends TileMap


const FIREWALL_OFFSET: float = 168.0 

signal on_level_finished

@export_group("Debug Options")
@export var debug_stop_scrolling: bool = false
@export var debug_start_at_checkpoint_number: int = -1
@export var debug_stop_music: bool = false

@export_group("Timing")
@export var scroll_speed: float = 50
@export var seconds_between_respawn: float = 1.0

@export_group("Scene References")
@export var player_scene: PackedScene
@export var checkpoints: Array[Area2D]

@export_group("HUD Text")
@export var death_texts: Array[String]
@export var checkpoint_text: String

@export_group("Outro")
@export var outro_marker_scene: PackedScene
@export var outro_camera_limit: float = -5032.0
@export var seconds_before_marker_appears: float = 5.0
@export var seconds_before_flight: float = 2.0
@export var flight_speed: float = -50.0
@export var seconds_before_flight_finished = 3.0

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var hud: CanvasLayer = $Camera/HUD
@onready var music_player: AudioStreamPlayer2D = $Camera/MusicPlayer
@onready var sfx_player: AudioStreamPlayer2D = $Camera/SFXPlayer
@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var outro_marker_spawn_location: Node2D = $OutroMarkerSpawnLocation
@onready var current_checkpoint: Area2D = checkpoints[0]


var player: CharacterBody2D
var total_deaths: int = 0
var scroll_level: bool = true
var outro_started: bool = false
var outro_finishing: bool = false


func _ready() -> void:
	if !debug_stop_music:
		music_player.play()
	_init_debug_options()
	_init_checkpoints()
	reset_level()

func _process(delta: float) -> void:
	if outro_finishing:
		player.position.y += flight_speed * delta

	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
	firewall.position.y += -scroll_speed * delta

	if camera.position.y <= outro_camera_limit:
		_play_outro()


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
	_reset_objects()


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


func _reset_objects() -> void:
	for object in get_tree().get_nodes_in_group("Resettable"):
		if object.has_method("reset_state"):
			object.reset_state()


func _init_checkpoints() -> void:
	for checkpoint in checkpoints:
		checkpoint.connect("on_player_entered", _on_checkpoint_reached)


func _on_checkpoint_reached(checkpoint: Area2D) -> void:
	if current_checkpoint != checkpoint:
		hud.show_central_notification(checkpoint_text)
		sfx_player.play_checkpoint_sfx()
		current_checkpoint = checkpoint


func _init_debug_options() -> void:
	get_tree().call_group("Debug", "queue_free")

	if debug_stop_scrolling:
		scroll_level = false

	if debug_start_at_checkpoint_number != -1 and debug_start_at_checkpoint_number < checkpoints.size():
		current_checkpoint = checkpoints[debug_start_at_checkpoint_number]


func _play_outro() -> void:
	scroll_level = false
	animations.play("bgm_fade_out")
	await get_tree().create_timer(seconds_before_marker_appears).timeout
	var outro_marker = load(outro_marker_scene.resource_path).instantiate()
	add_child(outro_marker)
	outro_marker.position = outro_marker_spawn_location.position
	outro_marker.connect("on_player_entered", _play_flight_animation)
	outro_marker.play_spawn_sequence()


func _play_flight_animation() -> void:
	player.freeze()
	player.enter_outro_state()
	sfx_player.play_checkpoint_sfx()
	await get_tree().create_timer(seconds_before_flight).timeout
	outro_finishing = true
	hud.fade_to_white()
	await get_tree().create_timer(seconds_before_flight_finished).timeout
	on_level_finished.emit()


func get_deaths() -> int:
	return total_deaths
