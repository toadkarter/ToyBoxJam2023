extends CanvasLayer


@export var notification_length_in_seconds: float = 1.2
@export var DeathCountText: String = "Armors Used:%d"

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var central_notification: Label = $CentralNotification
@onready var death_count_label: Label = $DeathCountLabel
@onready var fade_in_length: float = animations.get_animation("central_notification_fade_in").length


func _ready():
	death_count_label.text = (DeathCountText % 0).to_upper()


func show_central_notification(message: String, length_in_seconds: float = 0.0):
	central_notification.text = message.to_upper()

	animations.play("central_notification_fade_in")

	if length_in_seconds == 0.0:
		await get_tree().create_timer(notification_length_in_seconds).timeout
	else:
		await get_tree().create_timer(length_in_seconds).timeout


	animations.play_backwards("central_notification_fade_in")


func set_death_count_label(num_deaths: int):
	death_count_label.text = (DeathCountText % num_deaths).to_upper()

