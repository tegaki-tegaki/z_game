extends Character
class_name Enemy

@onready var aim_component: RayCast2D = $AimComponent
@onready var timers: Node2D = %timers

var has_target = false
var target: Vector2 = Vector2()

var _idle_target: Vector2
var _idle_timer: GameTimer

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
    
func new_idle_target():
    _idle_target = position + (Utils.rand_Vector2() * randf_range(50, 200))


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
        # state machine?... probably smart here
        if (_idle_target - position).length() <= 10:
            velocity = Vector2()
        else:
            velocity = (_idle_target - position).normalized() * (speed*0.3) * T.time_scale
        
    move_and_slide()


func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    if target.length() < 200:
        has_target = true
