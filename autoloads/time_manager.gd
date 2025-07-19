extends Node

var game_time := 0.0  # seconds

signal time_updated(delta)

func update(delta):
    game_time += delta
    time_updated.emit(delta)
