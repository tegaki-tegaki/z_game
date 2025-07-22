extends Node

var time_boost := 1.0 
var time_scale := 0.0:
  get = get_time_scale

signal changed_time_scale()

func get_time_scale() -> float:
  return time_scale * time_boost

func set_time_scale(new_time_scale: float):
    time_scale = new_time_scale
    changed_time_scale.emit(new_time_scale)

func set_time_boost(boost: float):
    time_boost = boost
