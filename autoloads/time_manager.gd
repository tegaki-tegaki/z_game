extends Node

var time_scale := 0.0

signal changed_time_scale()

func set_time_scale(new_time_scale: float):
    time_scale = new_time_scale
    changed_time_scale.emit(new_time_scale)
