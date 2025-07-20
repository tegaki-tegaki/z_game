class_name Player
extends CharacterBody2D

@onready var skin: Sprite2D = %skin

signal player_action(player)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass  # Replace with function body.


var speed = 60
var can_act = true




func act(delta, action_type: PlayerState.ActionType):
    T.update(delta)
    player_action.emit(PlayerState.new(self, action_type))


func _physics_process(delta):
    if can_act:
        handle_actions(delta)
    if !can_act:
        act(delta, PlayerState.ActionType.WAIT)
    aim_marker()


func handle_actions(delta):
    if handle_move(delta):
        return
    if handle_aim(delta):
        return
    if handle_fire(delta):
        return


func handle_aim(_delta):
    return false


func handle_fire(delta):
    var attempt_fire = Input.is_action_just_pressed("fire_weapon")
    if attempt_fire:
        var disable_act_timer = get_tree().create_timer(0.2)
        disable_act_timer.timeout.connect(enable_act)
        can_act = false
        act(delta, PlayerState.ActionType.FIRE)
        return true
    return false


func handle_move(delta):
    var input_vector = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )
    velocity = input_vector * speed
    if velocity.x > 0:
        transform.x = Vector2(1.0, 0.0)
    elif velocity.x < 0:
        transform.x = Vector2(-1.0, 0.0)
    move_and_slide()

    if input_vector.length() > 0:
        act(delta, PlayerState.ActionType.MOVE)
        return true


func aim_marker():
    var raycast = %aim_marker.get_node("raycast")
    raycast.target_position = get_local_mouse_position() - %aim_marker.position


func enable_act():
    can_act = true
