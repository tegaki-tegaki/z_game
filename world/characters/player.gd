class_name Player
extends CharacterBody2D

@onready var skin: Sprite2D = %skin

signal player_action(player)

@onready var bullets = get_tree().root.get_node("main/%bullets/raycasts")
@onready var bullet_decals = get_tree().root.get_node("main/%bullets/decals")

var speed = 60
var stamina = 100
var strength = 10
var can_act = true

var is_aiming = false
var aim_spread: float
var aim_direction: Vector2


func _ready() -> void:
    set_aim_spread()


func act(delta, action_type: PlayerState.ActionType):
    T.update(delta)
    player_action.emit(PlayerState.new(self, action_type))


func _physics_process(delta):
    if can_act:
        handle_actions(delta)
    else:
        act(delta, PlayerState.ActionType.WAIT)
    handle_modes()
    aim_marker()


func handle_actions(delta):
    if handle_move(delta):
        return
    if handle_aim(delta):
        return
    if handle_fire(delta):
        return
    if handle_reload(delta):
        return


func set_aim_spread():
    var wielded = %wield.get_child(0) as RangedWeapon
    var weapon = wielded.weapon
    aim_spread = PI
    if weapon:
        aim_spread = weapon.start_aim_spread


func handle_move(delta):
    var input_vector = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )
    var run_mode = Input.is_action_pressed("run_hold")

    if input_vector.length() > 0:
        velocity = input_vector * speed
        if velocity.x > 0:
            transform.x = Vector2(1.0, 0.0)
        elif velocity.x < 0:
            transform.x = Vector2(-1.0, 0.0)
        move_and_slide()

        if is_aiming:
            is_aiming = false
        set_aim_spread()

        var delta_mod = 1.0
        if run_mode:
            delta_mod = clamp(delta_mod - inverse_lerp(0, 20, strength), 0.1, 1)

        act(delta * delta_mod, PlayerState.ActionType.MOVE)

        return true


func handle_aim(delta):
    var attempt_aim = Input.is_action_pressed("aim_weapon")
    if attempt_aim:
        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon
        act(delta, PlayerState.ActionType.AIM)

        if !is_aiming:
            is_aiming = true
            set_aim_spread()

        aim_spread = move_toward(
            aim_spread, weapon.best_aim_spread, delta * weapon.aim_time_modifier
        )

        return true
    return false


func handle_fire(delta):
    var attempt_fire = Input.is_action_just_pressed("fire_weapon")
    if attempt_fire:
        disable_act(0.2)
        act(delta, PlayerState.ActionType.FIRE)

        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon
        var ammo = wielded.ammo

        if ammo && weapon.num_ammo:
            # play fire sound
            fire_ammo(ammo)
            weapon.num_ammo -= 1
            if weapon.num_ammo <= 0:
                wielded.ammo = null
        else:
            # play click sound
            pass

        return true
    return false


func fire_ammo(ammo: Ammo):
    for i in ammo.num_bullets:
        var aim_target = (
            %aim_marker.get_node("raycast").target_position as Vector2
        )
        var random_spread = randf_range(-aim_spread / 2, aim_spread / 2)
        var raycast = RayCast2D.new()
        raycast.position = %body.position + %aim_marker.position
        raycast.target_position = (aim_target.normalized()).rotated(
            random_spread
        )
        raycast.target_position *= 800  # use bullet / gun range?
        raycast.set_collision_mask_value(2, true)
        # NOTE: displacement of aim_marker makes this less predictable?
        raycast.hit_from_inside = true
        bullets.add_child(raycast)
    calculate_bullet_hits()


func calculate_bullet_hits():
    var wielded = %wield.get_child(0) as RangedWeapon
    var ammo = wielded.ammo

    for bullet_ray: RayCast2D in bullets.get_children():
        var hits = Utils.get_raycast_colliders(bullet_ray)
        print("bullet " + bullet_ray.name + " hit " + str(hits))
        var bullet_velocity = ammo.bullet_velocity_mps
        var zero_velocity_collider = null
        for hit: Enemy in hits:
            hit.damage(wielded, bullet_velocity)
            bullet_velocity -= 200  # TODO: something smarter
            if bullet_velocity <= 0:
                zero_velocity_collider = hit
                bullet_ray.remove_exception(hit)
        render_bullet(bullet_ray, zero_velocity_collider)
        bullet_ray.queue_free()


func render_bullet(bullet_ray: RayCast2D, terminal_collider: CharacterBody2D):
    var origin_point = bullet_ray.position
    var end_point = bullet_ray.target_position
    if terminal_collider:
        bullet_ray.force_raycast_update()
        end_point = bullet_ray.get_collision_point()
    var line = Line2D.new()

    line.width = 0.5
    line.default_color = Color(1.0, 1.0, 0.6)
    line.add_point(origin_point)
    line.add_point(end_point)

    bullet_decals.add_child(line)

    var tween = get_tree().create_tween()  # PERF: tween per bullet
    tween.parallel().tween_property(line, "modulate", Color.TRANSPARENT, 0.75)
    tween.parallel().tween_property(line, "width", 5.0, 0.75)
    tween.tween_callback(line.queue_free)


func handle_reload(delta):
    var attempt_reload = Input.is_action_just_pressed("reload_weapon")
    if attempt_reload:
        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon
        disable_act(1 * weapon.reload_time_modifier)
        act(delta, PlayerState.ActionType.RELOAD)

        const _00_SHOT = preload("res://resources/ammo/00_shot.tres")
        wielded.ammo = _00_SHOT
        weapon.num_ammo = 2

        return true
    return false


# this is only for non-time behaviour
func handle_modes():
    var status = get_node("%status") as Node2D
    status.position = %body.position
    var run_mode = Input.is_action_pressed("run_hold")
    var running = status.get_node("running") as Sprite2D
    if run_mode:
        running.visible = true
    else:
        running.visible = false


func aim_marker():
    var raycast = %aim_marker.get_node("raycast")
    raycast.position = %body.position
    raycast.target_position = (
        get_global_mouse_position() - (raycast.position + %aim_marker.position)
    )


func disable_act(duration_seconds: float):
    var disable_act_timer = get_tree().create_timer(duration_seconds)
    disable_act_timer.timeout.connect(enable_act)
    can_act = false


func enable_act():
    can_act = true
