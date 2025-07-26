class_name HealthBarComponent
extends ProgressBar

@onready var parent: Character = $".."

func _ready():
    value = 1.0
    position += Vector2(0, parent.creature.size)
    

func _process(_delta: float):
    if value >= 1.0 or value <= 0.0:
        visible = false
    else:
        visible = true
