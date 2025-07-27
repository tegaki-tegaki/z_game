extends Resource
class_name ItemResource

## used in inventory & damage calculations. cubic centimeters
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:cm3")
var volume_cm3: float
## used in inventory & damage calculations. kilograms
@export_range(9e-99, 9e99, 0.0000001, "hide_slider", "suffix:kg")
var mass_kg: float

enum ItemType { ITEM, CLOTHING, WEAPON, MEDICINE }
@export var type: ItemType

@export var name: String
@export var name_texture: String
@export var name_texture_on_person: String

@export var y_offset: float
@export var y_offset_wielding: float
@export var y_offset_wearing: float
## eg. shotgun_410, molle_pack
var texture: AtlasTexture
## eg. overlay_wielded_shotgun_410, overlay_male_worn_molle_pack
var texture_character: AtlasTexture


func get_inventory_data():
    return {"volume": volume_cm3, "mass": mass_kg}
