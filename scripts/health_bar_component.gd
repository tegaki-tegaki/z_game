class_name HealthBarComponent
extends ProgressBar

@export var body: BodyComponent

func _ready():
    value = 1.0
    position += Vector2(0, body.creature.size)
    

func _process(_delta: float):
    if value >= 1.0 or value <= 0.0:
        visible = false
    else:
        visible = true
