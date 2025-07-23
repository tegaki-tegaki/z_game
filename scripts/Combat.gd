class_name Combat

## Attempt to trigger [param shooter]'s wielded Weapon
##
## this is the "main combat entrypoint":
## Combat -> CombatComponent (injected) -> other...
## this anyone can try to call this passing in self, but
## it will fail if the calling object doesn't have a CombatComponent
## to provide this function with needed details.
static func trigger_weapon(shooter: Node2D):
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
    

static func fire_ammo(shooter: Node2D, ammo: AmmoResource, aim_ray: RayCast2D):
    print("AMMO FIRED")
    Utils.play_shot_sound(shooter, ammo.sound_pool.get_sound())
    var combat = shooter.get_node("CombatComponent") as CombatComponent

    for i in ammo.num_bullets:
        var random_spread = randf_range(-combat.aim_spread / 2, combat.aim_spread / 2)
        var raycast = RayCast2D.new()
        raycast.position = shooter.position + aim_ray.position
        raycast.target_position = (aim_ray.target_position.normalized()).rotated(
            random_spread
        )
        raycast.target_position *= 2000  # use bullet / gun range?
        raycast.set_collision_mask_value(1, false)
        raycast.set_collision_mask_value(2, true)
        # NOTE: displacement of aim_marker makes this less predictable?
        raycast.hit_from_inside = true
        C.bullets.add_child(raycast)
    calculate_bullet_hits(shooter)


static func calculate_bullet_hits(shooter: Node2D):
    var combat = shooter.get_node("CombatComponent") as CombatComponent
    var wielded = combat.get_wielded() as WieldedWeapon
    var ammo = wielded.loaded_ammo

    for bullet_ray: RayCast2D in C.bullets.get_children():
        var hits = Utils.get_raycast_colliders(bullet_ray)
        print("bullet " + bullet_ray.name + " hit " + str(hits))
        var bullet_velocity = ammo.bullet_velocity_mps
        var zero_velocity_collider = null
        for hit: Enemy in hits:
            hit.damage(wielded, bullet_velocity, bullet_ray.target_position)
            bullet_velocity -= 200  # TODO: something smarter
            if bullet_velocity <= 0:
                zero_velocity_collider = hit
                bullet_ray.remove_exception(zero_velocity_collider)
        C.render_bullet(bullet_ray, zero_velocity_collider)
        bullet_ray.queue_free()

# TODO: strange to weave out and back in to Combat?
# Combat.calculate_bullet_hits()
#   > entity.damage()
#     > Combat.calc_damage()
static func calc_damage(wielded: WieldedWeapon):
    # TODO: assumes ranged weapon... check both
    var weapon = wielded.get_weapon() as RangedWeaponResource
    var ammo = wielded.loaded_ammo as AmmoResource
    if !ammo:
      return 0
    var bullet_extra_dmg = ammo.bullet_extra_damage
    return weapon.weapon_extra_damage * bullet_extra_dmg * Utils.kinetic_energy(ammo)
