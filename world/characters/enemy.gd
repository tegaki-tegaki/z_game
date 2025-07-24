class_name Enemy
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D

var has_target = false
var target: Vector2 = Vector2()
var speed = 65
var health = 1000

## accumulate raw_damage from several sources within a tick.
## eg. if multiple shotgun bullets hit the same target.
var damage_within_tick = 0.0


func _ready() -> void:
    var player: Player = get_tree().root.get_node("main/%player")
    if player:
        player.player_action.connect(update_ai)


## [code]time_scale[/code] determines velocity
func _physics_process(_delta: float) -> void:
    if has_target:
        velocity = target.normalized() * speed * T.time_scale
    else:
        # TODO: something smarter (smells, idle behaviour... stuff)
        velocity = Vector2(randf(), randf()).normalized() * speed * T.time_scale
    if velocity.x > 0:
        sprite_2d.flip_h = false
    else:
        sprite_2d.flip_h = true
    move_and_slide()

    damage_within_tick = 0


func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    has_target = true


func damage(raw_damage: float, impact_vector: Vector2):
    health -= raw_damage
    damage_within_tick += raw_damage

    # blood decals
    var blood_tilemap = (
        get_tree().root.get_node("main/%terrain/blood") as TileMapLayer
    )
    var standing_tile = blood_tilemap.local_to_map(position)
    var behind_sample_vec = position + (impact_vector.normalized() * 32)
    var behind_tile = blood_tilemap.local_to_map(behind_sample_vec)

    if damage_within_tick >= 1000:
        blood_tilemap.set_cells_terrain_connect([behind_tile], 0, 3)
    else:
        blood_tilemap.set_cells_terrain_connect([behind_tile], 0, 1)

    if health <= 0:
        self.queue_free()
        blood_tilemap.set_cells_terrain_connect([standing_tile], 0, 2)
