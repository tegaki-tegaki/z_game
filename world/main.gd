extends Node2D
const ENEMY = preload("res://world/characters/enemy.tscn")
@onready var enemies: Node2D = $enemies


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    debug_spawn_monster_grid()
    pass


func debug_spawn_monster_grid():
    for i in range(0, 50):
        var monster = G.get_cdda_monster()
        var enemy = ENEMY.instantiate()
        var sprite = enemy.get_node("Sprite2D") as Sprite2D
        var label = enemy.get_node("name") as Label
        var collision_shape: CollisionShape2D = (
            enemy.get_node("%HitboxComponent") as CollisionShape2D
        )

        sprite.texture = monster.image_data.texture
        sprite.hframes = monster.image_data.hframes
        sprite.vframes = monster.image_data.vframes
        sprite.frame = monster.image_data.frame

        label.text = monster.name

        var shape = CircleShape2D.new()
        shape.radius = monster.size
        collision_shape.shape = shape
        collision_shape.position = Vector2(0.0, monster.offset_y)

        @warning_ignore("integer_division")
        enemy.position = Vector2((i % 5) * 300, i / 5 * 100)
        enemies.add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass
