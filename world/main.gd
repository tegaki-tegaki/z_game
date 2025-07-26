extends Node2D
const ENEMY = preload("res://world/characters/enemy.tscn")
const PLAYER = preload("res://world/characters/player.tscn")
@onready var enemies: Node2D = $enemies


func _ready() -> void:
    # spawn_player(Vector2(0, 0))
    spawn_player()
    # debug_spawn_monster_rect(Rect2(Vector2(), Vector2()))
    debug_spawn_monster_rect()


func spawn_player():
    var player = PLAYER.instantiate()
    var creature = preload("res://resources/creatures/human.tres")

    var body = player.get_node("BodyComponent") as BodyComponent
    body.load_creature(creature)

    add_child(player)


func debug_spawn_monster_rect():
    var creatures = [
        preload("res://resources/creatures/mon_zombie_brainless.tres"),
        preload("res://resources/creatures/mon_zombie_runner.tres")
    ]
    for i in range(0, 10):
        var enemy = ENEMY.instantiate()
        var collision_shape: CollisionShape2D = (
            enemy.get_node("HitboxComponent") as CollisionShape2D
        )

        var creature = creatures.pick_random()

        var body = enemy.get_node("BodyComponent") as BodyComponent
        body.load_creature(creature)

        var label = enemy.get_node("name") as Label
        label.text = creature.name

        var shape = CircleShape2D.new()
        shape.radius = creature.size
        collision_shape.shape = shape

        @warning_ignore("integer_division")
        enemy.position = Vector2((i % 5) * 300, i / 5 * 100)
        enemies.add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
