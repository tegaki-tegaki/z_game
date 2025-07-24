extends Node2D
class_name HealthComponent

@export var MAX_HEALTH := 1000.0
@export var HealthBar: HealthBarComponent = null
@onready var parent = get_parent()

var health: float

## accumulate raw_damage from several sources within a tick.
## eg. if multiple shotgun bullets hit the same target.
var __damage_within_tick = 0.0

func _ready():
    health = MAX_HEALTH

func damage(raw_damage: float, impact_vector: Vector2):
    health -= raw_damage
    __damage_within_tick += raw_damage

    var blood_tilemap = (
        get_tree().root.get_node("main/%terrain/blood") as TileMapLayer
    )
    var standing_tile = blood_tilemap.local_to_map(parent.position)
    var behind_sample_vec = parent.position + (impact_vector.normalized() * 32)
    var behind_tile = blood_tilemap.local_to_map(behind_sample_vec)

    # terrain 0 -> 3 blood intensity
    if __damage_within_tick >= 1000:
        blood_tilemap.set_cells_terrain_connect([behind_tile], 0, 3)
    else:
        blood_tilemap.set_cells_terrain_connect([behind_tile], 0, 1)

    if health <= 0:
        blood_tilemap.set_cells_terrain_connect([standing_tile], 0, 2)
        parent.queue_free()
        
    if HealthBar:
        HealthBar.value = inverse_lerp(0.0, MAX_HEALTH, health)
