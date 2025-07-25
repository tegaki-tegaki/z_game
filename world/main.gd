extends Node2D
const ENEMY = preload("res://world/characters/enemy.tscn")
@onready var enemies: Node2D = $enemies


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    debug_spawn_monster_grid()


func debug_spawn_monster_grid():
    var creatures = [
        preload("res://resources/creatures/mon_zombie_brainless.tres"),
        preload("res://resources/creatures/mon_zombie_runner.tres")
    ]
    for i in range(0, 10):
        var enemy = ENEMY.instantiate()
        var label = enemy.get_node("name") as Label
        var collision_shape: CollisionShape2D = (
            enemy.get_node("HitboxComponent") as CollisionShape2D
        )

        var body = enemy.get_node("BodyComponent") as BodyComponent

        var creature = creatures.pick_random()
        var textures = G.get_creature_textures(creature.name)
        creature.sprite = textures.texture
        creature.sprite_corpse = textures.corpse_texture

        body.creature = creature

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
