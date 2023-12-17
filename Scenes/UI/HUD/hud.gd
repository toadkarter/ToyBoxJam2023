extends CanvasLayer


@export var notification_length_in_seconds: float = 0.7

@onready var animations: AnimationPlayer = $AnimationPlayer
@onready var central_notification: Label = $CentralNotification


func show_central_notification(message: String):
	central_notification.text = message.to_upper()

	animations.play("central_notification_fade_in")
	await get_tree().create_timer(notification_length_in_seconds).timeout
	animations.play_backwards("central_notification_fade_in")
	