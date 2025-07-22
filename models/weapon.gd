extends Resource
class_name Weapon

## the name of the weapon
@export var weapon_name: String

## raw damage from gun (before bullets)
@export var gun_damage: float

## maximum number of ammo you can load
@export var max_num_ammo: int
## current number of ammo loaded
@export var num_ammo: int

## mult with delta when firing (how fast the gun fires)
@export var fire_time_modifier: float
## mult with delta when aiming (how quick it is to aim)
@export var aim_time_modifier: float
## modifier for reload_time
@export var reload_time_modifier: float

## larger angle when starting to aim
@export var start_aim_spread: float
## smallest angle after aiming, aka "steadiness" (current, regular -> careful -> precise)
@export var best_aim_spread: float

@export var compatible_ammo: Ammo.AmmoType
