extends Node

@onready var bullets = get_tree().root.get_node("main/%bullets/raycasts")
@onready var bullet_decals = get_tree().root.get_node("main/%bullets/decals")


# convention: *Data for data bundles
# better than Dictionary (it kinda sucky in gdscript)
class DamageCalcData:
    var wielded: WieldedWeapon
    var bullet_speed

    func _init(_wielded: WieldedWeapon, _bullet_speed = null):
        wielded = _wielded
        bullet_speed = _bullet_speed
        
class Attack:
    var raw_damage: float
    var impact_vector: Vector2
    
    func _init(_raw_damage: float, _impact_vector: Vector2):
        raw_damage = _raw_damage
        impact_vector = _impact_vector


## Attempt to trigger [param shooter]'s wielded Weapon
##
## this is the "main combat entrypoint":
## Combat -> CombatComponent (injected) -> other...
## this anyone can try to call this passing in self, but
## it will fail if the calling object doesn't have a CombatComponent
## to provide this function with needed details.
func trigger_weapon(shooter: Node2D):
    var combat = shooter.get_node("CombatComponent") as CombatComponent
    if !combat or !combat is CombatComponent:
        print("Warning: bad CombatComponent for " + str(shooter))
        return

    var aim_ray = combat.get_aim_ray()
    var wielded = combat.get_wielded()
    var weapon = wielded.get_weapon()

    if weapon is RangedWeaponResource:
        var ammo = wielded.loaded_ammo
        if ammo && wielded.loaded_ammo_num:
            fire_ammo(shooter, ammo, aim_ray)
            wielded.loaded_ammo_num -= 1
            if wielded.loaded_ammo_num <= 0:
                wielded.loaded_ammo = null
        else:
            # play click sound
            pass

    if weapon is MeleeWeaponResource:
        pass


func fire_ammo(shooter: Node2D, ammo: AmmoResource, aim_ray: RayCast2D):
    print("AMMO FIRED")
    Utils.play_shot_sound(shooter, ammo.sound_pool.get_sound())
    var combat = shooter.get_node("CombatComponent") as CombatComponent

    for i in ammo.num_bullets:
        var random_spread = randf_range(
            -combat.aim_spread / 2, combat.aim_spread / 2
        )
        var raycast = RayCast2D.new()
        raycast.position = shooter.position + aim_ray.position
        raycast.target_position = (
            (aim_ray.target_position.normalized()).rotated(random_spread)
        )
        raycast.target_position *= 2000  # use bullet / gun range?
        raycast.set_collision_mask_value(1, false)
        raycast.set_collision_mask_value(2, true)
        # NOTE: displacement of aim_marker makes this less predictable?
        raycast.hit_from_inside = true
        bullets.add_child(raycast)
    calculate_bullet_hits(shooter)


func calculate_bullet_hits(shooter: Node2D):
    var combat = shooter.get_node("CombatComponent") as CombatComponent
    var wielded = combat.get_wielded() as WieldedWeapon
    var ammo = wielded.loaded_ammo

    for bullet_ray: RayCast2D in C.bullets.get_children():
        var hits = Utils.get_raycast_colliders(bullet_ray)
        print("bullet " + bullet_ray.name + " hit " + str(hits))
        var bullet_velocity = ammo.bullet_velocity_mps
        var zero_velocity_collider = null
        for hit: Enemy in hits:
            var raw_damage = calc_damage(
                C.DamageCalcData.new(wielded, bullet_velocity)
            )
            hit.damage(raw_damage, bullet_ray.target_position)
            bullet_velocity -= 200  # TODO: something smarter
            if bullet_velocity <= 0:
                zero_velocity_collider = hit
                # NOTE: this exception removal will add every hit after 0 vel
                # but order is preserved so rendering stops at first 0 vel hit!
                bullet_ray.remove_exception(zero_velocity_collider)
        render_bullet(bullet_ray, zero_velocity_collider)
        bullet_ray.queue_free()


func calc_damage(data: DamageCalcData):
    var wielded = data.wielded as WieldedWeapon
    # TODO: assumes ranged weapon... check both
    var weapon = wielded.get_weapon() as RangedWeaponResource
    var ammo = wielded.loaded_ammo as AmmoResource
    if !ammo:
        return 0

    var bullet_velocity = ammo.bullet_velocity_mps
    if "bullet_velocity" in wielded:
        bullet_velocity = wielded.bullet_velocity

    var bullet_extra_dmg = ammo.bullet_extra_damage
    return (
        weapon.weapon_extra_damage
        * bullet_extra_dmg
        * Utils.kinetic_energy(ammo, bullet_velocity)
    )


func render_bullet(bullet_ray: RayCast2D, terminal_collider: CharacterBody2D):
    var origin_point = bullet_ray.position
    var end_point = origin_point + bullet_ray.target_position
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
