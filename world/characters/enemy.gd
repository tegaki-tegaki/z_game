extends Character
class_name Enemy

@onready var aim_component: RayCast2D = $AimComponent
@onready var timers: Node2D = %timers

var has_target = false
var target: Vector2 = Vector2()

var _idle_target: Vector2
var _idle_timer: GameTimer

var _attention_timer: GameTimer

var player = null


func get_player():
    if !player:
        var _player = get_tree().root.get_node("main/player")
        if _player:
            _player.player_action.connect(update_ai)
            player = _player


func _ready() -> void:
    super._ready()
    _idle_timer = GameTimer.new()
    _idle_timer.timeout.connect(new_idle_target)
    _idle_timer.start(randf_range(5, 10))
    timers.add_child(_idle_timer)
    new_idle_target()
    
    _attention_timer = GameTimer.new()
    _attention_timer.timeout.connect(func(): has_target = false)
    _attention_timer.one_shot = true
    timers.add_child(_attention_timer)

func new_idle_target():
    _idle_target = position + (Utils.rand_Vector2() * randf_range(50, 200))


## [code]time_scale[/code] determines velocity
func _physics_process(_delta: float) -> void:
    get_player()
    if is_dead:
        # not queue_free... could resurrect later
        return
    if has_target:
        if (target - position).length() <= 10:
            velocity = Vector2()
        else:
            velocity = (target - position).normalized() * speed * T.time_scale
            aim_component.target_position = (
                (target - position).normalized() * 50
            )
    else:
        # TODO: something smarter (smells, idle behaviour... stuff)
        # state machine?... probably smart here
        if (_idle_target - position).length() <= 10:
            velocity = Vector2()
        else:
            velocity = (
                (_idle_target - position).normalized()
                * (speed * 0.3)
                * T.time_scale
            )

    move_and_slide()


# TODO: replace growing logic with state machine
func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    if !target:
        return
    
    var to_player = position - player.position
    if to_player.length() < 200:
        target = player.position
        has_target = true
        _attention_timer.start(3.0)


func damage(raw_damage: float, impact_vector: Vector2):
    super.damage(raw_damage, impact_vector)
    target = (position +  (-1 * impact_vector.normalized())*200)
    has_target = true
    _attention_timer.start(3.0)
