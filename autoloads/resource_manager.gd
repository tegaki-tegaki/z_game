extends Node

static var images_data = {
    "small.png": {"texture": preload("res://resources/small.png"), "hframes": 16, "vframes": 110},
    "normal.png": {"texture": preload("res://resources/normal.png"), "hframes": 16, "vframes": 445},
    "tall.png": {"texture": preload("res://resources/tall.png"), "hframes": 16, "vframes": 44},
    "human_body.png":
    {"texture": preload("res://resources/human_body.png"), "hframes": 16, "vframes": 167},
    "human_body_plus.png":
    {"texture": preload("res://resources/human_body_plus.png"), "hframes": 16, "vframes": 38},
    "centered.png":
    {"texture": preload("res://resources/centered.png"), "hframes": 16, "vframes": 3},
    "large.png": {"texture": preload("res://resources/large.png"), "hframes": 8, "vframes": 34},
    "large_ridden.png":
    {"texture": preload("res://resources/large_ridden.png"), "hframes": 3, "vframes": 2},
    "huge.png": {"texture": preload("res://resources/huge.png"), "hframes": 4, "vframes": 8},
    "giant.png": {"texture": preload("res://resources/giant.png"), "hframes": 4, "vframes": 22},
    "incomplete_small.png":
    {"texture": preload("res://resources/incomplete_small.png"), "hframes": 16, "vframes": 1},
    "incomplete.png":
    {"texture": preload("res://resources/incomplete.png"), "hframes": 16, "vframes": 54},
    "incomplete_tall.png":
    {"texture": preload("res://resources/incomplete_tall.png"), "hframes": 16, "vframes": 1},
    "incomplete_body_plus.png":
    {"texture": preload("res://resources/incomplete_body_plus.png"), "hframes": 16, "vframes": 1},
    "incomplete_large.png":
    {"texture": preload("res://resources/incomplete_large.png"), "hframes": 8, "vframes": 11},
    "incomplete_giant.png":
    {"texture": preload("res://resources/incomplete_giant.png"), "hframes": 4, "vframes": 1},
    "fillerhoder.png":
    {"texture": preload("res://resources/fillerhoder.png"), "hframes": 16, "vframes": 4},
    "filler.png": {"texture": preload("res://resources/filler.png"), "hframes": 16, "vframes": 2},
    "filler_tall.png":
    {"texture": preload("res://resources/filler_tall.png"), "hframes": 1, "vframes": 1},
    "fillergiant.png":
    {"texture": preload("res://resources/fillergiant.png"), "hframes": 4, "vframes": 3},
    "fallback.png":
    {"texture": preload("res://resources/fallback.png"), "hframes": 16, "vframes": 256}
}

var config
var monsters


func _ready():
    config = Utils.load_json_config()
    monsters = Utils.process_config(config)


func get_cdda_monster():
    var enemy_data = monsters.pick_random()

    #var sprite = enemy.get_node("Sprite2D") as Sprite2D
    #var label = enemy.get_node("name") as Label

    var image_data = images_data[enemy_data.file_name]
    #sprite.texture = image_data.texture
    #sprite.hframes = image_data.hframes
    #sprite.vframes = image_data.vframes
    #sprite.frame = enemy_data.id

    var enemy_name
    if typeof(enemy_data.name) == TYPE_ARRAY:
        enemy_name = enemy_data.name[0]

        #enemy.position = Vector2(i % 10 * 300 + 300, (i / 10) * 100 + 100)
    else:
        enemy_name = enemy_data.name

        #enemy.position = Vector2(i % 10 * 300 + 300, (i / 10) * 100 + 100)
    return {"name": enemy_name, "image_data": image_data.merged({"frame": enemy_data.id})}
