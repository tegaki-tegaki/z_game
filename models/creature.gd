extends Resource
class_name CreatureResource

#@export var sprite_texture: String
#@export var sprite_hframes: int
#@export var sprite_vframes: int
#@export var sprite_frame: int
#
#@export var sprite_corpse_texture: String
#@export var sprite_corpse_hframes: int
#@export var sprite_corpse_vframes: int
#@export var sprite_corpse_frame: int

var sprite: AtlasTexture
var sprite_corpse: AtlasTexture

@export var size: float
@export var speed: float
@export var health: float
@export var name: String
@export var y_offset: float
