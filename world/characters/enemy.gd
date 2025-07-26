extends Character
class_name Enemy

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var aim_component: RayCast2D = $AimComponent
@onready var wield: Node2D = $wield

var has_target = false
var target: Vector2 = Vector2()

var player = null

func get_player():
    if !player:
        var _player = get_tree().root.get_node("main/player")
        if _player:
            _player.player_action.connect(update_ai)
            player = _player

func _ready() -> void:
    super._ready()
    pass


## [code]time_scale[/code] determines velocity
func _physics_process(_delta: float) -> void:
    get_player()
    if is_dead:
        return
    if has_target:
        velocity = target.normalized() * speed * T.time_scale
        aim_component.target_position = (
            (target - aim_component.position).normalized() * 50
        )
    else:
        # TODO: something smarter (smells, idle behaviour... stuff)
        velocity = Vector2(randf(), randf()).normalized() * speed * T.time_scale
    move_and_slide()


func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    has_target = true
