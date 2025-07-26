extends Character
class_name Player

signal player_action(player)

@onready var skin: Sprite2D = %skin
@onready var combat: CombatComponent = %CombatComponent
@onready var bullets = C.bullets
@onready var bullet_decals = C.bullet_decals
@onready var aim_component: AimComponent = $AimComponent

var can_act = true

var is_aiming = false
var aim_direction: Vector2


func _ready() -> void:
    super._ready()
    T.set_time_scale(0)
    set_aim_spread()


func set_aim_spread():
    var wielded = combat.get_wielded()
    var weapon = wielded.get_weapon()

    combat.aim_spread = PI
    if weapon:
        combat.aim_spread = weapon.start_aim_spread


func act(time_scale, action_type: PlayerState.ActionType):
    T.set_time_scale(time_scale)
    player_action.emit(PlayerState.new(self, action_type))


func _physics_process(delta):
    if can_act:
        handle_actions(delta)
    else:
        act(1.0, PlayerState.ActionType.WAIT)
    handle_modes()
    aim_marker()


func handle_actions(delta):
    T.set_time_scale(0)
    if handle_move():
        return
    if handle_aim(delta):
        return
    if handle_fire():
        return
    if handle_reload():
        return


func handle_move():
    var input_vector = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )
    var run_mode = Input.is_action_pressed("run_hold")

    if input_vector.length() > 0:
        velocity = input_vector * speed

        if is_aiming:
            is_aiming = false
        set_aim_spread()

        var delta_mod = 1.0
        if run_mode:
            delta_mod = clamp(delta_mod - inverse_lerp(0, 20, strength), 0.1, 1)

        act(1.0 * delta_mod, PlayerState.ActionType.MOVE)

        move_and_slide()

        return true
    return false


func handle_aim(delta):
    var attempt_aim = Input.is_action_pressed("aim_weapon")
    if attempt_aim:
        var wielded = combat.get_wielded()
        var weapon = wielded.get_weapon()

        act(1.0, PlayerState.ActionType.AIM)

        if !is_aiming:
            is_aiming = true
            set_aim_spread()

        combat.aim_spread = move_toward(
            combat.aim_spread,
            weapon.best_aim_spread,
            delta * weapon.aim_time_modifier
        )

        return true
    return false


func handle_fire():
    var attempt_fire = Input.is_action_just_pressed("fire_weapon")
    if attempt_fire:
        disable_act(0.2)
        act(1.0, PlayerState.ActionType.FIRE)
        C.trigger_weapon(self)
        return true
    return false


func handle_reload():
    var attempt_reload = Input.is_action_just_pressed("reload_weapon")
    if attempt_reload:
        var wielded = combat.get_wielded()
        var weapon = wielded.get_weapon()

        Utils.play_reload_sound(self, weapon.sound_pool.get_sound())
        act(1.0, PlayerState.ActionType.RELOAD)
        disable_act(1 * weapon.reload_time_modifier, 3.0)

        const _00_SHOT = preload("res://resources/ammo/00_shot.tres")
        wielded.loaded_ammo = _00_SHOT
        wielded.loaded_ammo_num = 2

        return true
    return false


# this is only for non-time behaviour
func handle_modes():
    var status = %status as Node2D
    status.position = body.base.position
    var run_mode = Input.is_action_pressed("run_hold")
    var running = status.get_node("running") as Sprite2D
    if run_mode:
        running.visible = true
    else:
        running.visible = false


func aim_marker():
    aim_component.target_position = (
        get_local_mouse_position() - aim_component.position
    )


func disable_act(duration_seconds: float, boost = 1.0):
    var disable_act_timer = get_tree().create_timer(
        duration_seconds * (1 / boost)
    )
    T.set_time_boost(boost)
    disable_act_timer.timeout.connect(enable_act)
    can_act = false


func enable_act():
    T.set_time_boost(1.0)
    can_act = true
