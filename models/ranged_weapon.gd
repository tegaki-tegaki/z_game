extends Resource
class_name RangedWeaponResource

## the name of the weapon
@export var weapon_name: String

## raw damage from weapon (excluding projectiles)
@export var weapon_extra_damage: float

## maximum number of ammo you can load
@export var max_num_ammo: int
@export var compatible_ammo: AmmoResource.AmmoType

## mult with delta when attacking (how fast the gun fires)
@export var attack_time_modifier: float
## mult with delta when aiming (how quick it is to aim)
@export var aim_time_modifier: float
## modifier for reload_time
@export var reload_time_modifier: float

## larger angle when starting to aim
@export var start_aim_spread: float
## smallest angle after aiming, aka "steadiness" (current, regular -> careful -> precise)
@export var best_aim_spread: float

@export var sound_pool: SoundPool

@export var sprite_texture: String
@export var sprite_hframes: int
@export var sprite_vframes: int
@export var sprite_frame: int

@export var sprite_world_texture: String
@export var sprite_world_hframes: int
@export var sprite_world_vframes: int
@export var sprite_world_frame: int
