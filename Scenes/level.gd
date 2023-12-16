extends TileMap


@export var scroll_level: bool = true
@export var scroll_speed: float = 5

@onready var camera: Camera2D = $Camera
@onready var firewall: Node2D = $Firewall
@onready var player: CharacterBody2D = $Player # TODO: Access this dynamically


func _ready() -> void:
	player.connect("on_death", _on_player_death)


func _process(delta: float) -> void:
	if !scroll_level:
		return

	camera.position.y += -scroll_speed * delta
	firewall.position.y += -scroll_speed * delta


func _on_player_death() -> void:
	scroll_level = false