extends RigidBody2D
class_name Item

@onready var sprite: Sprite2D = %sprite
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var contains: Node2D = $contains
@onready var label: Label = $label

var resource: ItemResource
var owner_: Character
var durability = 1.0
var flip_h: bool


func _ready():
    _set_sprite_state(State.WORLD)
    name = resource.name
    label.text = resource.name


func _process(_delta: float):
    if owner_:
        sprite.flip_h = owner_.body.direction == G.Direction.LEFT

## must load item upon instantiation, before adding to the tree
func load_item(item: ItemResource):
    var texture = G.get_gameobj_texture(item.name_texture)
    item.texture = texture

    var texture_character = G.get_gameobj_texture(
        item.name_texture_character
    )
    item.texture_character = texture_character

    resource = item


enum State { WORLD, CHARACTER, INSERTED }


func _set_sprite_state(state: State):
    match state:
        State.WORLD:
            sprite.texture = resource.texture
            sprite.visible = true
        State.CHARACTER:
            sprite.texture = resource.texture_character
            sprite.visible = true
        State.INSERTED:
            sprite.visible = false


func drop(wielder: Character):
    _set_sprite_state(State.WORLD)
    collision.disabled = false
    reparent(get_tree().root.get_node("%items"))
    owner = null
    position = wielder.position


func wield(wielder: Character):
    _set_sprite_state(State.CHARACTER)
    collision.disabled = true
    reparent(wielder.body.wielding, false)
    owner_ = wielder
    position = Vector2(0, 0)


func wear(wearer: Character):
    _set_sprite_state(State.CHARACTER)
    collision.disabled = true
    reparent(wearer.body.wearing, false)
    owner_ = wearer
    position = Vector2(0, 0)


func store(inserter: Character, container: Item):
    _set_sprite_state(State.INSERTED)
    collision.disabled = true
    reparent(container.contains, false)
    owner_ = inserter
    position = Vector2(0, 0)


func damage(attack: C.Attack):
    durability -= attack.raw_damage
    if durability <= 0:
        destroy()


func destroy():
    # spawn items
    queue_free()


func disassemble():
    # spawn items
    pass


func get_mass_():
    var mass_ = resource.mass_kg
    if contains:
        for item in contains.get_children():
            mass_ += item.get_mass_()
    return mass_


func get_volume():
    return resource.volume_cm3


func get_storage():
    return resource.storage_cm3


func get_used_storage():
    var used_storage = 0.0
    if contains:
        for item in contains.get_children():
            used_storage += item.get_volume()
    return used_storage
