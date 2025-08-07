extends Node2D
const ITEM = preload("res://world/item_types/item.tscn")
const WEAPON = preload("res://world/item_types/weapon.tscn")
const CLOTHING = preload("res://world/item_types/clothing.tscn")
const ENEMY = preload("res://world/characters/enemy.tscn")
const PLAYER = preload("res://world/characters/player.tscn")
@onready var enemies: Node2D = $enemies
@onready var items: Node2D = $items

@export var game_over: SoundPool


func _ready() -> void:
    spawn_player(Vector2(0, 0))

    var cluster = Vector2(100, 100)
    debug_spawn_enemy_rect(Rect2(Vector2(-1000, -250), cluster), 1)
    debug_spawn_enemy_rect(Rect2(Vector2(300, -2000), cluster), 1)
    debug_spawn_enemy_rect(Rect2(Vector2(0, 1000), cluster), 1)
    debug_spawn_enemy_rect(
        Rect2(Vector2(-8000, -8000), Vector2(16000, 16000)), 0.001
    )
    #debug_spawn_enemy_rect(
    #Rect2(Vector2(8000, 0), Vector2(1000, 1000)), 0.2
    #)

    var hulk = preload("res://resources/creatures/mon_zombie_hulk.tres")
    spawn_enemy(Vector2(100, -800), hulk)

    var sweater = preload("res://resources/clothing/sweater.tres")
    spawn_item(Vector2(-70, 50), sweater)
    spawn_item(Vector2(-70, 60), sweater)
    spawn_item(Vector2(-70, 70), sweater)

    var pants = preload("res://resources/clothing/cargo_pants.tres")
    spawn_item(Vector2(-80, 70), pants)
    spawn_item(Vector2(-80, 80), pants)
    spawn_item(Vector2(-80, 90), pants)

    var shotgun = preload("res://resources/weapons/shotgun.tres")
    spawn_item(Vector2(-120, 70), shotgun)
    
    var mp5k = preload("res://resources/weapons/hk_mp5k.tres")
    spawn_item(Vector2(-120, 80), mp5k)


func spawn_player(location: Vector2):
    var player = PLAYER.instantiate()
    player.position = location

    var creature = preload("res://resources/creatures/human.tres")
    player.load_creature(creature)

    add_child(player)


func spawn_enemy(location: Vector2, creature: CreatureResource):
    var enemy = ENEMY.instantiate()

    enemy.load_creature(creature)

    enemy.position = location
    enemies.add_child(enemy)


func spawn_item(location: Vector2, resource: ItemResource):
    var item
    if resource is RangedWeaponResource || resource is MeleeWeaponResource:
        item = WEAPON.instantiate()
        item.load_weapon(resource)
    elif resource is ClothingResource:
        item = CLOTHING.instantiate()
        item.load_clothing(resource)
    elif resource is ItemResource:
        item = ITEM.instantiate()
        item.load_item(resource)
    else:
        print("spawn_item() tried to spawn non-item")

    item.position = location
    items.add_child(item)


## [param density] how much to fill the rect with enemies
func debug_spawn_enemy_rect(rect: Rect2, density: float):
    var _density = clamp(density, 0, 0.5)
    var creatures = [
        [
            preload("res://resources/creatures/mon_zombie_brainless.tres"),
            10.0
        ],
        [
            preload("res://resources/creatures/mon_zombie_runner.tres"),
            10.0
        ],
        [preload("res://resources/creatures/mon_zombie_hulk.tres"), 0.01],
    ]
    var _only_creatures = creatures.map(func(c): return c[0])
    var occupant_size = ceil(
        (
            _only_creatures.reduce(func(acc, c): return acc + c.size, 0)
            / _only_creatures.size()
        )
    )
    var area = rect.get_area()
    var spawn_count = int((area / (occupant_size * 2) ** 2) * _density)
    for i in spawn_count:
        var creature = Utils.weighted_random_pick(creatures)

        @warning_ignore("integer_division")
        # enemy.position = Vector2((i % 5) * 300, i / 5 * 100)
        var rand_x = randf_range(
            rect.position.x, rect.position.x + rect.size.x
        )
        var rand_y = randf_range(
            rect.position.y, rect.position.y + rect.size.y
        )
        spawn_enemy(Vector2(rand_x, rand_y), creature)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
