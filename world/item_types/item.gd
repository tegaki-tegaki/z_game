extends Node2D
class_name Item

var resource: ItemResource
@onready var sprite: Sprite2D = %sprite

var durability = 1.0


func _ready():
    _set_sprite_state(State.WORLD)


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


func drop(_wielder: Character):
    _set_sprite_state(State.WORLD)
    reparent(get_tree().root.get_node("%items"))


func wield(wielder: Character):
    _set_sprite_state(State.CHARACTER)
    reparent(wielder.body.wielding)


func wear(wearer: Character):
    _set_sprite_state(State.CHARACTER)
    reparent(wearer.body.wearing)


func insert(_inserter: Character, container: Item):
    _set_sprite_state(State.INSERTED)
    reparent(container)


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
