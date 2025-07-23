@tool
extends Node2D
class_name Weapon

@export var ranged: RangedWeaponResource = null:
    set(value):
        ranged = value
        update_configuration_warnings()
@export var melee: MeleeWeaponResource = null:
    set(value):
        melee = value
        update_configuration_warnings()


func _get_configuration_warnings():
    if ranged and melee:
        return ["max one resource per weapon"]
    if !ranged and !melee:
        return ["must define one resource"]
    return []


func get_weapon():
    if ranged:
        return ranged
    if melee:
        return melee
    print("only define one weapon")


func _ready():
    # set sprites from resource data
    pass
