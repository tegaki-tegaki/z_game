extends Resource
class_name MeleeWeaponResource

## the name of the weapon
@export var weapon_name: String

## raw damage from weapon
@export var weapon_extra_damage: float

## mult with delta when attacking
@export var attack_time_modifier: float

@export var sound_pool: SoundPool

@export var sprite_texture: String
@export var sprite_hframes: int
@export var sprite_vframes: int
@export var sprite_frame: int

@export var sprite_world_texture: String
@export var sprite_world_hframes: int
@export var sprite_world_vframes: int
@export var sprite_world_frame: int
