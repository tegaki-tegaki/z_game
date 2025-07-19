extends Node2D
const ENEMY = preload("res://characters/enemy.tscn")
@onready var enemies: Node2D = $enemies


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    for i in range(0, 50):
        var monster = G.get_cdda_monster()
        var enemy = ENEMY.instantiate()
        var sprite = enemy.get_node("Sprite2D") as Sprite2D
        var label = enemy.get_node("name") as Label

        sprite.texture = monster.image_data.texture
        sprite.hframes = monster.image_data.hframes
        sprite.vframes = monster.image_data.vframes
        sprite.frame = monster.image_data.frame

        label.text = monster.name

        @warning_ignore("integer_division")
        enemy.position = Vector2((i % 6) * 300 + 150, i / 6 * 100 + 100)
        enemies.add_child(enemy)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    pass


func _on_spawn_enemy(enemy_data):
    print("spawn_enemy: ", enemy_data)
