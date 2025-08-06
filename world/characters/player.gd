class_name Player
extends Character

signal player_action(player)

@onready var bullets = C.bullets
@onready var bullet_decals = C.bullet_decals
@onready var camera: Camera2D = $Camera2D

@export var damage_sounds: SoundPool
@export var death_sounds: SoundPool

var interact: InteractionComponent
var aim_component: AimComponent

var can_act = true

enum Mode { AIMING, MOVING, INTERACT_STORE, INTERACT_EQUIP }
var mode: Mode = Mode.MOVING
var aim_direction: Vector2


func _ready() -> void:
    aim_component = get_meta(AimComponent.N)
    interact = get_meta(InteractionComponent.N)
    super._ready()

    T.set_time_scale(0)
    set_aim_spread()


func set_aim_spread():
    interact.aim_spread = PI

    var wielded = interact.get_wielded()
    if !wielded:
        return
    var weapon = wielded.get_weapon()
    if weapon:
        interact.aim_spread = weapon.start_aim_spread


func act(time_scale, action_type: PlayerState.ActionType):
    T.set_time_scale(time_scale)
    player_action.emit(PlayerState.new(self, action_type))


func _physics_process(delta):
    if !is_dead && can_act:
        handle_actions(delta)
    else:
        act(1.0, PlayerState.ActionType.WAIT)
    handle_status()
    handle_interact()
    aim_marker()
    zoom()


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


func handle_interact():
    handle_equip_target()
    handle_store_target()
    interact_marker()


func interact_marker():
    var interact_target = get_tree().root.get_node("main/interact_target")
    interact_target.visible = false
    if [Mode.INTERACT_STORE, Mode.INTERACT_EQUIP].has(mode):
        var item = interact.reachable_item()
        if item:
            interact_target.position = item.position
            interact_target.visible = true
            item.display_label()


func handle_equip_target():
    var attempt_equip = Input.is_action_just_pressed("equip_target")
    if attempt_equip:
        mode = Mode.INTERACT_EQUIP
        return true
    return false


func handle_store_target():
    var attempt_store = Input.is_action_just_pressed("grab_target")
    if attempt_store:
        mode = Mode.INTERACT_STORE
        return true
    return false


func handle_move():
    var input_vector = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )
    var run_mode = Input.is_action_pressed("run_hold")

    if input_vector.length() > 0:
        velocity = input_vector * speed

        mode = Mode.MOVING
        set_aim_spread()

        var total_delta_mod = 1.0
        var str_mod = total_delta_mod - inverse_lerp(0, 20, strength)
        var mass_mod = get_mass()
        if run_mode:
            total_delta_mod = clamp(str_mod * mass_mod, 0.1, 1)
        stamina -= velocity.length() * total_delta_mod

        act(1.0 * total_delta_mod, PlayerState.ActionType.MOVE)
        move_and_slide()

        return true
    return false


func handle_aim(delta):
    var attempt_aim = Input.is_action_pressed("aim_weapon")
    if attempt_aim:
        if !mode == Mode.AIMING:
            mode = Mode.AIMING
            set_aim_spread()

        var wielded = interact.get_wielded()
        if !wielded:
            return
        var weapon = wielded.get_weapon()

        act(1.0, PlayerState.ActionType.AIM)

        interact.aim_spread = move_toward(
            interact.aim_spread,
            weapon.best_aim_spread,
            delta * weapon.aim_time_modifier
        )

        return true
    return false


func handle_fire():
    var attempt_fire = Input.is_action_just_pressed("fire_weapon")
    if attempt_fire:
        if mode == Mode.INTERACT_STORE:
            interact.store_targeted()
            return true
        if mode == Mode.INTERACT_EQUIP:
            interact.equip_targeted()
            return true
        if mode == Mode.AIMING or mode == Mode.MOVING:
            disable_act(0.2)
            act(1.0, PlayerState.ActionType.FIRE)
            C.trigger_weapon(self)
            return true
    return false


func handle_reload():
    var attempt_reload = Input.is_action_just_pressed("reload_weapon")
    if attempt_reload:
        var wielded = interact.get_wielded() as Weapon
        if !wielded:
            return
        var weapon = wielded.get_weapon()

        Utils.play_sound(%audio/reload, weapon.sound_pool.get_sound())
        act(1.0, PlayerState.ActionType.RELOAD)
        disable_act(1 * weapon.reload_time_modifier, 3.0)

        const _00_SHOT = preload("res://resources/ammo/00_shot.tres")
        wielded.loaded_ammo = _00_SHOT
        wielded.loaded_ammo_num = 2

        return true
    return false


# this is only for non-time behaviour
func handle_status():
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


var camera_zoom = 1.0


func zoom():
    var inputs = [
        "zoom_in",
        "zoom_out",
    ]
    for input in inputs:
        if Input.is_action_just_pressed(input):
            match input:
                "zoom_out":
                    camera_zoom = move_toward(camera_zoom, 0.5, 0.5)
                "zoom_in":
                    camera_zoom = move_toward(camera_zoom, 5.0, 0.5)
    camera.zoom = Vector2(camera_zoom, camera_zoom)


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


func damage(raw_damage, impact_vector):
    super.damage(raw_damage, impact_vector)
    Utils.play_sound(%audio/damage, damage_sounds.get_sound())


func set_dead():
    super.set_dead()
    Utils.play_sound(%audio/damage, death_sounds.get_sound())
