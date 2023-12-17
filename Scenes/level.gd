extends TileMap


@export var scroll_level: bool = true
@export var scroll_speed: float = 5
@export var player_scene: PackedScene

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var checkpoint: Node2D = $Checkpoint
# @onready var player: CharacterBody2D = $Player # TODO: Access this dynamically


func _ready() -> void:
	var player = load(player_scene.resource_path).instantiate()
	add_child(player)
	player.position = checkpoint.position
	player.connect("on_death", _on_player_death)


func _process(delta: float) -> void:
	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
	firewall.position.y += -scroll_speed * delta


func _on_player_death() -> void:
	print("Hello")
	scroll_level = false