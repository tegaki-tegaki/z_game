class_name ItemResource
extends Resource

## used in inventory & damage calculations. cubic centimeters
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:cm3")
var volume_cm3: float
## used in inventory & damage calculations. kilograms
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:kg")
var mass_kg: float

enum ItemType { ITEM, CLOTHING, WEAPON, MEDICINE }
@export var type: ItemType

@export var storage_cm3: float
@export var storage_length_cm: float

## UI name
@export var name: String
## eg. shotgun_410, molle_pack
@export var name_texture: String
## eg. overlay_wielded_shotgun_410, overlay_male_worn_molle_pack
@export var name_texture_character: String

@export var y_offset: float
@export var y_offset_character: float
var texture: AtlasTexture
var texture_character: AtlasTexture


func get_inventory_data():
    return {
        "volume": volume_cm3,
        "mass": mass_kg,
        "storage": storage_cm3,
        "storage_length": storage_length_cm
    }
