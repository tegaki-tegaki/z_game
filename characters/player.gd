class_name Player
extends CharacterBody2D

@onready var skin: Sprite2D = %skin

signal player_action(player)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass  # Replace with function body.


var speed = 60
var flip_h = false
var can_act = true


func _physics_process(delta):
    if can_act:
        var input_vector = Input.get_vector(
            "move_left", "move_right", "move_up", "move_down"
        )
        self.velocity = input_vector * speed
        if velocity.x > 0:
            flip_h = false
        elif velocity.x < 0:
            flip_h = true
        move_and_slide()

        if input_vector.length() > 0:
            T.update(delta)
            player_action.emit(self)

        var attempt_fire = Input.is_action_just_pressed("fire_weapon")
        if attempt_fire:
            var disable_act_timer = get_tree().create_timer(0.2)
            disable_act_timer.timeout.connect(enable_act)
            can_act = false
    else:
        T.update(delta)
        player_action.emit(self)


func enable_act():
    can_act = true
