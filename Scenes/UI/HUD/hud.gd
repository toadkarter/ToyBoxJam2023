extends CanvasLayer


@export var notification_length_in_seconds: float = 1.2

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var central_notification: Label = $CentralNotification
@onready var fade_in_length: float = animations.get_animation("central_notification_fade_in").length


func show_central_notification(message: String, length_in_seconds: float = 0.0):
	central_notification.text = message.to_upper()

	animations.play("central_notification_fade_in")

	if length_in_seconds == 0.0:
		await get_tree().create_timer(notification_length_in_seconds).timeout
	else:
		await get_tree().create_timer(length_in_seconds).timeout


	animations.play_backwards("central_notification_fade_in")
	