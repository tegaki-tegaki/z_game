extends Area2D
class_name Item

var resource: ItemResource
@onready var sprite: Sprite2D = %sprite
@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var contains: Node2D = $contains

var durability = 1.0


func _ready():
    _set_sprite_state(State.WORLD)
    name = resource.name


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
    reparent(get_tree().root.get_node("%items"), false)
    position = wielder.position
    collision.disabled = false


func wield(wielder: Character):
    _set_sprite_state(State.CHARACTER)
    reparent(wielder.body.wielding, false)
    position = Vector2(0, 0)
    collision.disabled = true

func wear(wearer: Character):
    _set_sprite_state(State.CHARACTER)
    reparent(wearer.body.wearing, false)
    position = Vector2(0, 0)
    collision.disabled = true

func store(_inserter: Character, container: Item):
    _set_sprite_state(State.INSERTED)
    reparent(container.contains)
    position = Vector2(0, 0)
    collision.disabled = true

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
    
func get_mass():
    var mass = resource.mass_kg
    if contains:
        for item in contains.get_children():
            mass += item.get_mass()
    return mass
    
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
