extends Node
class_name CombatComponent

var aim_spread: float

func get_aim_ray() -> RayCast2D:
    var aim_ray = get_parent().get_node("%AimComponent") as RayCast2D
    return aim_ray
    

func get_wielded() -> WieldedWeapon:
    var weapon = get_parent().get_node("%wield").get_child(0)
    # TODO: if empty => fists weapon
    return weapon
