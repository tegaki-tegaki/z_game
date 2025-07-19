class_name Player
extends CharacterBody2D

signal player_action(player)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass  # Replace with function body.

var speed = 50

func _physics_process(delta):
    var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
    self.velocity = input_vector * speed
    move_and_slide()

    if input_vector.length() > 0:
        T.update(delta)
        player_action.emit(self)
