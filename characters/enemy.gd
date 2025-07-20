extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D

var has_target = false
var target: Vector2 = Vector2()
var speed = 50


func _ready() -> void:
    T.time_updated.connect(act)
    var player: Player = get_tree().root.get_node("main/%player")
    if player:
        player.player_action.connect(update_ai)


# we will not use _process within enemies
# they will move when player ticks time
func act(delta):
    if has_target:
        velocity = target.normalized() * speed
    else:
        velocity = Vector2()
    if velocity.x > 0:
        sprite_2d.flip_h = false
    else:
        sprite_2d.flip_h = true
    move_and_slide()


func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    has_target = true
