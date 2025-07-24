class_name HealthBarComponent
extends ProgressBar

func _ready():
    value = 1.0

func _process(_delta: float):
    if value >= 1.0:
        visible = false
    else:
        visible = true
