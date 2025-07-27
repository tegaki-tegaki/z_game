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


func get_storage() -> float:
    var wielded_ = Utils.first(wielding) as Weapon
    var wearing_ = wearing.get_children()

    var wielding_storage = 0.0
    if wielded_:
        wielding_storage += wielded_.get_storage()

    var wearing_storage = 0.0
    for worn in wearing_:
        wearing_storage += worn.get_storage()

    return wielding_storage + wearing_storage


func get_used_storage() -> float:
    var wearing_ = wearing.get_children()

    var wearing_used_storage = 0.0
    for worn: Item in wearing_:
        wearing_used_storage += worn.get_used_storage()

    return wearing_used_storage
