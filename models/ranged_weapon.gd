class_name RangedWeaponResource
extends ItemResource

@export var weapon_data: WeaponDataResource
@export var sound_pool: SoundPool

## maximum number of ammo you can load
@export var compatible_ammo: AmmoResource.AmmoType
@export var max_num_ammo: int

## mult with delta when aiming (how quick it is to aim)
@export var aim_time_modifier: float
## modifier for reload_time
@export var reload_time_modifier: float

## larger angle when starting to aim
@export var start_aim_spread: float
## smallest angle after aiming, aka "steadiness" (current, regular -> careful -> precise)
@export var best_aim_spread: float
