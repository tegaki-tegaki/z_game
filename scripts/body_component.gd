extends Node2D
class_name BodyComponent

@export var aim: AimComponent
@export var creature: CreatureResource
@onready var base: Sprite2D = $base

func _ready():
    base.texture = creature.sprite
    position.y = creature.y_offset
    
func _process(_delta: float):
    if aim.target_position.x > 0:
        transform.x = Vector2.RIGHT
    elif aim.target_position.x < 0:
        transform.x = Vector2.LEFT
        
func set_dead():
    base.texture = creature.sprite_corpse
