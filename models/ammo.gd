extends Resource
class_name Ammo

@export var ammo_name: String

## raw individual bullet damage.
## Usually 1, this is "extra damage" beyond
## it's kinetic energy, so think eg. explosive rounds
@export var bullet_extra_damage: float
## number of bullets per cartridge
@export var num_bullets: int

## used in inventory & damage calculations. cubic centimeters
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:cm3") var bullet_volume_cm3: float
## used in inventory & damage calculations. kilograms
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:kg") var bullet_mass_kg: float
## used in inventory calculations. cubic centimeters
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:cm3") var cartridge_volume_cm3: float
## used in inventory calculations. kilograms
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:kg")  var cartridge_mass_kg: float
## muzzle velocity in meters per second
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:mps") var bullet_velocity_mps: float
## Hardness of the bullet in BHN.
## Used in damage, pierce & penetration calculations
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:BHN") var bullet_hardness_bhn: float 

enum AmmoType {SHELLS, _d902mm, _d907mm, _d457mm}
@export var ammo_type: AmmoType 

@export var texture: AtlasTexture

func get_inventory_data():
    return {
        "volume": cartridge_volume_cm3,
        "mass": (bullet_mass_kg * num_bullets) + cartridge_mass_kg
    }
