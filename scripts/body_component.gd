extends Node2D
class_name BodyComponent

@export var aim: AimComponent
@export var creature: CreatureResource
@onready var base: Sprite2D = $base


func _process(_delta: float):
    if aim.target_position.x > 0:
        transform.x = Vector2.RIGHT
    elif aim.target_position.x < 0:
        transform.x = Vector2.LEFT


func get_mass() -> float:
    var wielded = get_node("wielding").get_child(0) as Weapon
    var wearing = get_node("wearing").get_children()

    var wielding_mass = 0.0
    if wielded:
        wielded.get_mass()

    var wearing_mass = 0.0
    for worn in wearing:
        wearing_mass += worn.get_mass()

    return wielding_mass + wearing_mass + creature.mass_kg
