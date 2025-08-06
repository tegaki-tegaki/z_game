class_name Enemy
extends Character

@onready var timers: Node2D = %timers

var aim_component: RayCast2D

var has_target = false
var target: Vector2 = Vector2()

var _idle_target: Vector2
var _idle_timer: GameTimer

var _attention_timer: GameTimer

var _attack_timer: GameTimer
var _target_in_reach = false

var player = null

static var REACH = 30.0


func get_player():
    if !player:
        var _player = get_tree().root.get_node("main/player") as Player
        if _player && !_player.is_dead:
            _player.player_action.connect(update_ai)
            player = _player
    if player && player.is_dead:
        var _player = player as Player
        _player.player_action.disconnect(update_ai)
        player = null


func _ready() -> void:
    aim_component = get_meta(AimComponent.N)
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

    _attack_timer = GameTimer.new()
    _attack_timer.timeout.connect(trigger_attack)
    timers.add_child(_attack_timer)


func trigger_attack():
    # TODO: try swing / sample Area2D collider
    if player:
        if (player.position - position).length() < REACH:
            player.damage(100, player.position - position)


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
            velocity = (
                (target - position).normalized() * speed * T.time_scale
            )
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


func _enable_attack():
    _target_in_reach = true

    if !_attack_timer.started:
        trigger_attack()
        _attack_timer.start(1.0)


func _disable_attack():
    _target_in_reach = false


# TODO: replace growing logic with state machine
func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    if is_dead:
        return

    var to_player = position - player.position
    if to_player.length() < 400:
        target = player.position
        has_target = true
        _attention_timer.start(10.0)
    if to_player.length() < REACH:
        _enable_attack()
    else:
        _disable_attack()


func damage(raw_damage: float, impact_vector: Vector2):
    super.damage(raw_damage, impact_vector)
    target = (
        position
        + (-1 * impact_vector.normalized()) * randf_range(200, 1500)
    )
    has_target = true
    _attention_timer.start(15.0)


func set_dead():
    super.set_dead()
    has_target = false
    _disable_attack()
    _attention_timer.queue_free()
    _attack_timer.queue_free()
    # TODO: respawn timer?
