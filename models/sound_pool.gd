extends Resource
class_name SoundPool

@export var sounds: Array[AudioStream]

func get_sound() -> AudioStream:
  var sound = sounds.pick_random() as AudioStream
  return sound
