extends Node2D
class_name BodyComponent

@export var aim: AimComponent
@export var creature: CreatureResource
@onready var base: Sprite2D = $base
@onready var wearing: Node2D = $wearing
@onready var wielding: Node2D = $wielding
@onready var parent: Character = $".."
var direction: G.Direction = G.Direction.RIGHT


func _ready():
    pass


func _process(_delta: float):
    if parent.is_dead:
        return
    if aim.target_position.x > 0:
        direction = G.Direction.RIGHT
    elif aim.target_position.x < 0:
        direction = G.Direction.LEFT
    if base:
        base.flip_h = direction == G.Direction.LEFT


func get_mass() -> float:
    var wielded_ = Utils.first(wielding) as Weapon
    var wearing_ = wearing.get_children()

    var wielding_mass = 0.0
    if wielded_:
        wielding_mass += wielded_.get_mass_()

    var wearing_mass = 0.0
    for worn in wearing_:
        wearing_mass += worn.get_mass_()

    return wielding_mass + wearing_mass + creature.mass_kg


func get_storage() -> float:
    var wielding_storage = 0.0
    var wielded_ = Utils.first(wielding) as Weapon
    if wielded_:
        wielding_storage += wielded_.get_storage()

    var wearing_storage = 0.0
    var wearing_ = wearing.get_children()
    for worn in wearing_:
        wearing_storage += worn.get_storage()

    return wielding_storage + wearing_storage


func get_used_storage() -> float:
    var wearing_used_storage = 0.0
    var wearing_ = wearing.get_children()
    for worn: Item in wearing_:
        var contents = worn.contains.get_children()
        for item: Item in contents:
            wearing_used_storage += item.get_volume()

    return wearing_used_storage


func store_item(item: Item):
    var wearing_ = wearing.get_children()
    for worn: Item in wearing_:
        var remaining_storage = (
            worn.get_storage() - worn.get_used_storage()
        )
        if remaining_storage >= item.get_volume():
            item.store(parent, worn)
