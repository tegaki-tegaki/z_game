class_name Utils

# the fg (and bg) ids refer to the "global" id,
# to be interpreted as if all tilesets were stitched together
# subtract one of these values to get a "local" id within a tileset
static var image_tile_offsets = {
    "small.png": 0,
    "normal.png": 1760,
    "tall.png": 8880,
    "human_body.png": 9584,
    "human_body_plus.png": 12256,
    "centered.png": 12864,
    "large.png": 12900,
    "large_ridden.png": 13172,
    "huge.png": 13178,
    "giant.png": 13210,
    "incomplete_small.png": 13298,
    "incomplete.png": 13314,
    "incomplete_tall.png": 14178,
    "incomplete_body_plus.png": 14194,
    "incomplete_large.png": 14210,
    "incomplete_giant.png": 14298,
    "fillerhoder.png": 14302,
    "filler.png": 14366,
    "filler_tall.png": 14398,
    "fillergiant.png": 14400,
    # "fallback.png": 14412
}


static func get_image_id(image_tile, global_image_id):
    return global_image_id - image_tile_offsets[image_tile]


static func find_tile_data(tiles, target: String) -> Variant:
    for tile in tiles:
        if typeof(tile.id) == TYPE_STRING && tile.id == target:
            return tile
        if typeof(tile.id) == TYPE_ARRAY:
            for id in tile.id:
                if id == target:
                    return tile
    return null


# target string is a prefix
static func filter_tile_data(tiles, target: String) -> Variant:
    var filtered = []
    for tile in tiles:
        if typeof(tile.id) == TYPE_STRING && tile.id.begins_with(target):
            filtered.append(tile)
        if typeof(tile.id) == TYPE_ARRAY:
            for id in tile.id:
                if id.begins_with(target):
                    filtered.append(tile)
    return filtered


# TODO: i don't like higher order functions...
static func process_monsters(file):
    return func(monster):
        if (
            typeof(monster) != TYPE_DICTIONARY
            || typeof(monster.fg) != TYPE_FLOAT
        ):
            # NOTE: probably a better way? (some have multiple ids map to one fg + vice versa)
            return null
        return {
            "file_name": file,
            "name": monster.id,
            "id": get_image_id(file, monster.fg),
        }


static func process_config(config):
    var monsters = []
    for tile_data in config["tiles-new"]:
        var tiles = tile_data.tiles
        var monsters_chunk_raw = filter_tile_data(tiles, "mon_zombie")
        var monsters_chunk = monsters_chunk_raw.map(
            process_monsters(tile_data.file)
        )
        monsters.append_array(monsters_chunk)
    monsters = monsters.filter(func(m): return m != null)
    return monsters


static func load_json_config():
    var file_json = FileAccess.get_file_as_string(
        "res://images/tile_config.json"
    )
    var config = JSON.parse_string(file_json)

    if config:
        return config


static func calc_damage(rangedWeapon: RangedWeapon):
    var weapon = rangedWeapon.weapon as Weapon
    var ammo = rangedWeapon.ammo as Ammo
    if !ammo:
      return 0
    var bullet_extra_dmg = ammo.bullet_extra_damage
    return weapon.gun_damage * bullet_extra_dmg * kinetic_energy(ammo)


static func kinetic_energy(ammo: Ammo):
    return 0.5 * ammo.bullet_mass_kg * (ammo.bullet_velocity_mps ** 2)
