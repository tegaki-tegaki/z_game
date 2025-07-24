extends Node
class_name CombatComponent

@export var aim: AimComponent

var aim_spread: float

func get_aim_ray() -> RayCast2D:
    return aim
    

func get_wielded() -> WieldedWeapon:
    var weapon = get_parent().get_node("%wield").get_child(0)
    # TODO: if empty => fists weapon
    return weapon
