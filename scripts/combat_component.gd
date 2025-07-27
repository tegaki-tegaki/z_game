extends Node
class_name CombatComponent

@export var aim: AimComponent

var aim_spread: float


func get_aim_ray() -> RayCast2D:
    return aim


func get_wielded() -> Weapon:
    var weapon = Utils.first(get_parent().get_node("BodyComponent/wielding"))
    # TODO: if empty => fists weapon
    return weapon


func set_wielded(weapon: Weapon):
    get_parent().get_node("BodyComponent/wielding").add_child(weapon)
