extends Node

# the fg (and bg) ids refer to the "global" id,
# to be interpreted as if all tilesets were stitched together
# subtract one of these values to get a "local" id within a tileset
static var images_data = {
    "small.png":
    {
        "id_offset": 0,
        "texture": preload("res://images/small.png"),
        "tile_size":
        {
            "x": 20,
            "y": 20,
        }
    },
    "normal.png":
    {
        "id_offset": 1760,
        "texture": preload("res://images/normal.png"),
        "tile_size":
        {
            "x": 32,
            "y": 32,
        }
    },
    "tall.png":
    {
        "id_offset": 8880,
        "texture": preload("res://images/tall.png"),
        "tile_size":
        {
            "x": 32,
            "y": 64,
        }
    },
    "human_body.png":
    {
        "id_offset": 9584,
        "texture": preload("res://images/human_body.png"),
        "tile_size":
        {
            "x": 32,
            "y": 36,
        }
    },
    "human_body_plus.png":
    {
        "id_offset": 12256,
        "texture": preload("res://images/human_body_plus.png"),
        "tile_size":
        {
            "x": 32,
            "y": 48,
        }
    },
    "centered.png":
    {
        "id_offset": 12864,
        "texture": preload("res://images/centered.png"),
        "tile_size":
        {
            "x": 64,
            "y": 64,
        }
    },
    "large.png":
    {
        "id_offset": 12900,
        "texture": preload("res://images/large.png"),
        "tile_size":
        {
            "x": 64,
            "y": 64,
        }
    },
    "large_ridden.png":
    {
        "id_offset": 13172,
        "texture": preload("res://images/large_ridden.png"),
        "tile_size":
        {
            "x": 64,
            "y": 64,
        }
    },
    "huge.png":
    {
        "id_offset": 13178,
        "texture": preload("res://images/huge.png"),
        "tile_size":
        {
            "x": 64,
            "y": 96,
        }
    },
    "giant.png":
    {
        "id_offset": 13210,
        "texture": preload("res://images/giant.png"),
        "tile_size":
        {
            "x": 96,
            "y": 96,
        }
    },
    "incomplete_small.png":
    {
        "id_offset": 13298,
        "texture": preload("res://images/incomplete_small.png"),
        "tile_size":
        {
            "x": 20,
            "y": 20,
        }
    },
    "incomplete.png":
    {
        "id_offset": 13314,
        "texture": preload("res://images/incomplete.png"),
        "tile_size":
        {
            "x": 32,
            "y": 32,
        }
    },
    "incomplete_tall.png":
    {
        "id_offset": 14178,
        "texture": preload("res://images/incomplete_tall.png"),
        "tile_size":
        {
            "x": 32,
            "y": 64,
        }
    },
    "incomplete_body_plus.png":
    {
        "id_offset": 14194,
        "texture": preload("res://images/incomplete_body_plus.png"),
        "tile_size":
        {
            "x": 32,
            "y": 48,
        }
    },
    "incomplete_large.png":
    {
        "id_offset": 14210,
        "texture": preload("res://images/incomplete_large.png"),
        "tile_size":
        {
            "x": 64,
            "y": 64,
        }
    },
    "incomplete_giant.png":
    {
        "id_offset": 14298,
        "texture": preload("res://images/incomplete_giant.png"),
        "tile_size":
        {
            "x": 96,
            "y": 96,
        }
    },
    "fillerhoder.png":
    {
        "id_offset": 14302,
        "texture": preload("res://images/fillerhoder.png"),
        "tile_size":
        {
            "x": 32,
            "y": 32,
        }
    },
    "filler.png":
    {
        "id_offset": 14366,
        "texture": preload("res://images/filler.png"),
        "tile_size":
        {
            "x": 32,
            "y": 32,
        }
    },
    "filler_tall.png":
    {
        "id_offset": 14398,
        "texture": preload("res://images/filler_tall.png"),
        "tile_size":
        {
            "x": 32,
            "y": 64,
        }
    },
    "fillergiant.png":
    {
        "id_offset": 14400,
        "texture": preload("res://images/fillergiant.png"),
        "tile_size":
        {
            "x": 96,
            "y": 96,
        }
    },
    "fallback.png":
    {
        "id_offset": 14412,
        "texture": preload("res://images/fallback.png"),
        "tile_size":
        {
            "x": 32,
            "y": 32,
        }
    }
}

var gameobj_data = Dict.new()


func _ready():
    var config = Utils.load_json_file("res://images/tile_config.json")
    process_config(config)


static func get_gameobj_atlastexture(
    creature_data, image_data
) -> AtlasTexture:
    var texture = AtlasTexture.new()
    texture.atlas = image_data.texture

    var rand_colrow = creature_data.colrows.pick_random()

    var x = image_data.tile_size.x * rand_colrow.x
    var y = image_data.tile_size.y * rand_colrow.y
    var w = image_data.tile_size.x
    var h = image_data.tile_size.y

    texture.region = Rect2(x, y, w, h)

    return texture


func process_config(config):
    for tile_data in config["tiles-new"]:
        var tiles = tile_data.tiles
        var tile_data_chunk_raw = tiles  # filter_tile_data(tiles)
        for tile_data_chunk in tile_data_chunk_raw:
            get_tile_to_gameobj_fn(gameobj_data, tile_data.file).call(
                tile_data_chunk
            )


# TODO: can higher order function be reduced?
# this function has also grown too large and complicated
static func get_tile_to_gameobj_fn(_gameobj_data, filename):
    return func(monster):
        var global_id = null
        if "fg" in monster:
            if typeof(monster.fg) == TYPE_ARRAY:
                if typeof(monster.fg[0]) == TYPE_FLOAT:
                    global_id = monster.fg
                elif "sprite" in monster.fg[0]:
                    global_id = []
                    for _fg in monster.fg:
                        global_id.append(_fg.sprite)
            elif typeof(monster.fg) == TYPE_FLOAT:
                global_id = monster.fg
            else:
                return

        else:
            if typeof(monster.bg) != TYPE_FLOAT:
                return
            global_id = monster.bg

        if typeof(monster) != TYPE_DICTIONARY:
            return

        var image_data = images_data[filename]
        var image_texture = image_data.texture as Texture2D
        var image_dim = image_texture.get_size()
        var tile_size = Vector2i(
            image_data.tile_size.x, image_data.tile_size.y
        )

        var colrows = []

        if typeof(global_id) == TYPE_ARRAY:
            for id in global_id:
                var image_local_id = get_image_id(filename, id)
                var colrow = global_id_to_xy_colrow(
                    image_dim, tile_size, image_local_id
                )

                colrows.append(colrow)

        else:
            var image_local_id = get_image_id(filename, global_id)
            var colrow = global_id_to_xy_colrow(
                image_dim, tile_size, image_local_id
            )

            colrows.append(colrow)

        if typeof(monster.id) == TYPE_ARRAY:
            for id in monster.id:
                _gameobj_data.set(
                    id, {"file": filename, "colrows": colrows}
                )
        else:
            _gameobj_data.set(
                monster.id, {"file": filename, "colrows": colrows}
            )


static func global_id_to_xy_colrow(
    image_dim: Vector2i, tile_size: Vector2i, id: int
) -> Vector2i:
    var tiles_per_row = image_dim.x / tile_size.x
    var x = id % tiles_per_row
    var y = id / tiles_per_row
    return Vector2i(x, y)


static func get_image_id(filename: String, global_image_id: int):
    return global_image_id - images_data[filename].id_offset


static func find_tile_data(tiles, target: String) -> Variant:
    for tile in tiles:
        if typeof(tile.id) == TYPE_STRING && tile.id == target:
            return tile
        if typeof(tile.id) == TYPE_ARRAY:
            for id in tile.id:
                if id == target:
                    return tile
    return null


# TODO: might be fine without filtering if
# i refactor from Dictionary -> class + array of classes
static func filter_tile_data(tiles) -> Variant:
    var filtered = []
    for tile in tiles:
        if typeof(tile.id) == TYPE_STRING:
            if (
                tile.id.begins_with("mon_zombie")
                || tile.id.begins_with("corpse_")
            ):
                filtered.append(tile)
        if typeof(tile.id) == TYPE_ARRAY:
            for id in tile.id:
                if (
                    id.begins_with("mon_zombie")
                    || id.begins_with("corpse_")
                ):
                    filtered.append(tile)
    return filtered


static var MISSING_TEXTURE_DATA = {
    "file": "incomplete.png", "colrows": [Vector2i(0, 0)]
}


## [param name_id] is the unique ids used in tile_config.json
## eg. "mon_zombie_brainless", "overlay_male_mutation_SKIN_TAN"
func get_creature_textures(name_id: String):
    var creature_data = gameobj_data.get(name_id)
    if !creature_data:
        creature_data = MISSING_TEXTURE_DATA
    var filename = creature_data.file
    var image_data = images_data[filename]
    var texture = get_gameobj_atlastexture(creature_data, image_data)

    var corpse_creature_data = gameobj_data.get("corpse_" + name_id)
    if !corpse_creature_data:
        corpse_creature_data = MISSING_TEXTURE_DATA
    var corpse_filename = corpse_creature_data.file
    var corpse_image_data = images_data[corpse_filename]
    var corpse_texture = get_gameobj_atlastexture(
        corpse_creature_data, corpse_image_data
    )

    return CreatureTextures.new(texture, corpse_texture)


func get_gameobj_texture(name_id: String) -> AtlasTexture:
    var _gameobj_data = gameobj_data.get(name_id)
    if !_gameobj_data:
        _gameobj_data = MISSING_TEXTURE_DATA
    var filename = _gameobj_data.file
    var image_data = images_data[filename]
    var texture = get_gameobj_atlastexture(_gameobj_data, image_data)

    return texture


class CreatureTextures:
    var texture: AtlasTexture
    var corpse_texture: AtlasTexture

    func _init(_texture, _corpse_texture):
        texture = _texture
        corpse_texture = _corpse_texture

#class GameobjData:
#var file: String
#var x_count: int
#var y_count: int
#
#class GameobjContainer:
#var objects: Array[GameobjData]
