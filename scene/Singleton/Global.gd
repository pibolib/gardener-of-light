extends Node2D

@onready var bgm = $BGM

func play_bgm(bgm_stream: AudioStreamOggVorbis) -> void:
	if bgm.playing:
		await stop_bgm()
	bgm.volume_db = 0
	bgm.stream = bgm_stream
	bgm.play()

func stop_bgm(time: float = 1) -> void:
	var tween := get_tree().create_tween()
	tween.tween_property(bgm, "volume_db", -80, time)
	tween.set_ease(Tween.EASE_OUT)
	await tween.finished
