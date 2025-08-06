extends Node
class_name InteractionComponent

@onready var parent: Character = $".."
@export var aim: AimComponent

var aim_spread: float

const REACH_DISTANCE = 35.0


func get_aim_ray() -> RayCast2D:
    return aim


func get_wielded() -> Weapon:
    var weapon = Utils.first(
        get_parent().get_node("BodyComponent/wielding")
    )
    # TODO: if empty => fists weapon
    return weapon


## try to store targeted item
func store_targeted():
    var item = reachable_item() as Item
    if item:
        parent.get_node("BodyComponent").store_item(item)


## try to wield targeted weapon, or wear targeted clothing
func equip_targeted():
    var item = reachable_item() as Item
    if item:
        if item is Weapon:
            item.wield(parent)
        elif item is Clothing:
            item.wear(parent)


enum InteractType { EQUIP, STORE }


func reachable_item() -> Item:
    var debug_target = get_tree().root.get_node("main/debug_target")

    var raycast = RayCast2D.new()
    raycast.collide_with_areas = true
    raycast.hit_from_inside = true
    raycast.position = parent.position + aim.position
    raycast.target_position = aim.target_position
    raycast.set_collision_mask_value(1, false)
    raycast.set_collision_mask_value(3, true)
    get_tree().root.get_node("main").add_child(raycast)
    raycast.force_raycast_update()
    var item = raycast.get_collider() as Item
    #debug_target.position = Vector2(collision_point_rel) + parent.position
    raycast.free()

    if item is Item:
        var distance = (item.position - parent.position).length()
        if distance <= REACH_DISTANCE:
            return item
    return null
