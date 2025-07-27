extends Node2D
class_name BodyComponent

@export var aim: AimComponent
@export var creature: CreatureResource
@onready var base: Sprite2D = $base
@onready var wearing: Node2D = $wearing
@onready var wielding: Node2D = $wielding
@onready var parent: Character = $".."

func _ready():
    pass

func _process(_delta: float):
    if aim.target_position.x > 0:
        transform.x = Vector2.RIGHT
    elif aim.target_position.x < 0:
        transform.x = Vector2.LEFT


func get_mass() -> float:
    var wielded_ = Utils.first(wielding) as Weapon
    var wearing_ = wearing.get_children()

    var wielding_mass = 0.0
    if wielded_:
        wielding_mass += wielded_.get_mass()

    var wearing_mass = 0.0
    for worn in wearing_:
        wearing_mass += worn.get_mass()

    return wielding_mass + wearing_mass + creature.mass_kg

    
