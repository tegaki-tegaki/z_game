class_name GameTimer
extends Node
## A special timer that only progresses with T.time_scale

signal timeout

var wait_time: float
var started: bool
var one_shot: bool

var _progress: float


func _init():
    _progress = 0.0
    started = false
    one_shot = false


func _physics_process(delta: float):
    if started:
        _tick(delta)


func _tick(delta):
    _progress += delta * T.time_scale
    if _progress >= wait_time:
        timeout.emit()
        _progress = 0.0
        if one_shot:
            started = false


func start(wait_time_ = -1):
    if wait_time_ >= 0:
        wait_time = wait_time_
    started = true
