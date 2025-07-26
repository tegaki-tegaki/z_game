extends Node2D
const ENEMY = preload("res://world/characters/enemy.tscn")
const PLAYER = preload("res://world/characters/player.tscn")
@onready var enemies: Node2D = $enemies


func _ready() -> void:
    spawn_player(Vector2(0, 0))

    var cluster = Vector2(100, 100)
    debug_spawn_enemy_rect(Rect2(Vector2(-1000, -250), cluster), 1)
    debug_spawn_enemy_rect(Rect2(Vector2(300, -2000), cluster), 1)
    debug_spawn_enemy_rect(Rect2(Vector2(0, 400), cluster), 1)


func spawn_player(location: Vector2):
    var player = PLAYER.instantiate()
    player.position = location

    var creature = preload("res://resources/creatures/human.tres")

    var body = player.get_node("BodyComponent") as BodyComponent
    body.load_creature(creature)

    add_child(player)


## [param density] how much to fill the rect with enemies
func debug_spawn_enemy_rect(rect: Rect2, density: float):
    var _density = clamp(density, 0, 0.5)
    var creatures = [
        preload("res://resources/creatures/mon_zombie_brainless.tres"),
        preload("res://resources/creatures/mon_zombie_runner.tres"),
        preload("res://resources/creatures/mon_zombie_hulk.tres")
    ]
    var occupant_size = ceil(
        (
            creatures.reduce(func(acc, c): return acc + c.size, 0)
            / creatures.size()
        )
    )
    var area = rect.get_area()
    var spawn_count = int((area / (occupant_size * 2) ** 2) * _density)
    for i in spawn_count:
        var enemy = ENEMY.instantiate()
        var creature = creatures.pick_random()

        var body = enemy.get_node("BodyComponent") as BodyComponent
        body.load_creature(creature)

        var label = enemy.get_node("name") as Label
        label.text = creature.name

        var collision_shape: CollisionShape2D = (
            enemy.get_node("HitboxComponent") as CollisionShape2D
        )
        var shape = CircleShape2D.new()
        shape.radius = creature.size
        collision_shape.shape = shape

        @warning_ignore("integer_division")
        # enemy.position = Vector2((i % 5) * 300, i / 5 * 100)
        var rand_x = randf_range(
            rect.position.x, rect.position.x + rect.size.x
        )
        var rand_y = randf_range(
            rect.position.y, rect.position.y + rect.size.y
        )
        enemy.position = Vector2(rand_x, rand_y)
        enemies.add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
