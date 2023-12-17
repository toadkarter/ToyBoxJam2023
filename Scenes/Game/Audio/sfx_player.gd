extends AudioStreamPlayer2D


@export var checkpoint_sfx: AudioStreamWAV
@export var death_sfx: AudioStreamWAV


func play_checkpoint_sfx() -> void:
	_play_sfx(checkpoint_sfx)


func play_death_sfx() -> void:
	_play_sfx(death_sfx)


func _play_sfx(in_stream: AudioStreamWAV):
	stream = in_stream
	play()
	
