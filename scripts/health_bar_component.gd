class_name HealthBarComponent
extends ProgressBar

const N = &"HealthBarComponent"

@onready var parent: Character = $".."


func _enter_tree():
    assert(owner is Character)
    owner.set_meta(N, self)


func _exit_tree():
    owner.remove_meta(N)


func _ready():
    value = 1.0
    position += Vector2(0, parent.creature.size)


func _process(_delta: float):
    if value >= 1.0 or value <= 0.0:
        visible = false
    else:
        visible = true
