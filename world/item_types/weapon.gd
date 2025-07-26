@tool
extends Node2D
class_name Weapon

@export var ranged: RangedWeaponResource = null
@export var melee: MeleeWeaponResource = null

var loaded_ammo: AmmoResource
var loaded_ammo_num: int

func get_weapon():
    if ranged:
        return ranged
    if melee:
        return melee
    print("only define one weapon")


func load_weapon(weapon: ItemResource):
    var texture = G.get_gameobj_texture(weapon.name_texture)
    weapon.texture = texture
    var texture_on_person = G.get_gameobj_texture(
        weapon.name_texture_on_person
    )
    weapon.texture = texture_on_person

    if weapon is RangedWeaponResource:
        ranged = weapon
    if weapon is MeleeWeaponResource:
        melee = weapon


func get_mass() -> float:
    if ranged:
        var weapon_mass = ranged.get_inventory_data().mass
        var ammo_mass = 0.0
        if loaded_ammo:
            ammo_mass = loaded_ammo.get_inventory_data().mass * loaded_ammo_num
        return ammo_mass + weapon_mass
    if melee:
        return melee.get_inventory_data().mass
    return 0.0


func _ready():
    var weapon = get_weapon()

    %sprite.texture = weapon.texture
    %sprite_world.texture = weapon.texture_on_person
