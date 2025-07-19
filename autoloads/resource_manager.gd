extends Node

static var sizes = {
    "small": 7, "normal": 10, "large": 20, "huge": 25, "giant": 30
}
static var offsets = {
    "small": -16, "normal": -14, "large": -8, "huge": -4, "giant": 0
}

static var images_data = {
    "small.png":
    {
        "texture": preload("res://resources/small.png"),
        "hframes": 16,
        "vframes": 110,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "normal.png":
    {
        "texture": preload("res://resources/normal.png"),
        "hframes": 16,
        "vframes": 445,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "tall.png":
    {
        "texture": preload("res://resources/tall.png"),
        "hframes": 16,
        "vframes": 44,
        "size": sizes["normal"],
        "offset_y": offsets["large"]
    },
    "human_body.png":
    {
        "texture": preload("res://resources/human_body.png"),
        "hframes": 16,
        "vframes": 167,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "human_body_plus.png":
    {
        "texture": preload("res://resources/human_body_plus.png"),
        "hframes": 16,
        "vframes": 38,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "centered.png":
    {
        "texture": preload("res://resources/centered.png"),
        "hframes": 16,
        "vframes": 3,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "large.png":
    {
        "texture": preload("res://resources/large.png"),
        "hframes": 8,
        "vframes": 34,
        "size": sizes["large"],
        "offset_y": offsets["large"]
    },
    "large_ridden.png":
    {
        "texture": preload("res://resources/large_ridden.png"),
        "hframes": 3,
        "vframes": 2,
        "size": sizes["large"],
        "offset_y": offsets["large"]
    },
    "huge.png":
    {
        "texture": preload("res://resources/huge.png"),
        "hframes": 4,
        "vframes": 8,
        "size": sizes["huge"],
        "offset_y": offsets["huge"]
    },
    "giant.png":
    {
        "texture": preload("res://resources/giant.png"),
        "hframes": 4,
        "vframes": 22,
        "size": sizes["giant"],
        "offset_y": offsets["giant"]
    },
    "incomplete_small.png":
    {
        "texture": preload("res://resources/incomplete_small.png"),
        "hframes": 16,
        "vframes": 1,
        "size": sizes["small"],
        "offset_y": offsets["small"]
    },
    "incomplete.png":
    {
        "texture": preload("res://resources/incomplete.png"),
        "hframes": 16,
        "vframes": 54,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "incomplete_tall.png":
    {
        "texture": preload("res://resources/incomplete_tall.png"),
        "hframes": 16,
        "vframes": 1,
        "size": sizes["normal"],
        "offset_y": offsets["large"]
    },
    "incomplete_body_plus.png":
    {
        "texture": preload("res://resources/incomplete_body_plus.png"),
        "hframes": 16,
        "vframes": 1,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "incomplete_large.png":
    {
        "texture": preload("res://resources/incomplete_large.png"),
        "hframes": 8,
        "vframes": 11,
        "size": sizes["large"],
        "offset_y": offsets["large"]
    },
    "incomplete_giant.png":
    {
        "texture": preload("res://resources/incomplete_giant.png"),
        "hframes": 4,
        "vframes": 1,
        "size": sizes["giant"],
        "offset_y": offsets["giant"]
    },
    "fillerhoder.png":
    {
        "texture": preload("res://resources/fillerhoder.png"),
        "hframes": 16,
        "vframes": 4,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "filler.png":
    {
        "texture": preload("res://resources/filler.png"),
        "hframes": 16,
        "vframes": 2,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    },
    "filler_tall.png":
    {
        "texture": preload("res://resources/filler_tall.png"),
        "hframes": 1,
        "vframes": 1,
        "size": sizes["normal"],
        "offset_y": offsets["large"]
    },
    "fillergiant.png":
    {
        "texture": preload("res://resources/fillergiant.png"),
        "hframes": 4,
        "vframes": 3,
        "size": sizes["giant"],
        "offset_y": offsets["giant"]
    },
    "fallback.png":
    {
        "texture": preload("res://resources/fallback.png"),
        "hframes": 16,
        "vframes": 256,
        "size": sizes["normal"],
        "offset_y": offsets["normal"]
    }
}

var config
var monsters


func _ready():
    config = Utils.load_json_config()
    monsters = Utils.process_config(config)


func get_cdda_monster():
    var enemy_data = monsters.pick_random()
    var image_data = images_data[enemy_data.file_name]
    var enemy_name

    if typeof(enemy_data.name) == TYPE_ARRAY:
        enemy_name = enemy_data.name[0]
    else:
        enemy_name = enemy_data.name

    var offset_y = 0
    if image_data.get("offset_y") != null:
        offset_y = image_data.get("offset_y")

    var monster = {
        "name": enemy_name,
        "image_data": image_data.merged({"frame": enemy_data.id}),
        "size": image_data.size,
        "offset_y": offset_y
    }

    return monster
