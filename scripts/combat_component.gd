extends Node
class_name InteractionComponent

const N = &"CombatComponent"

@export var aim: AimComponent

const REACH_DISTANCE = 35.0

var aim_spread: float

func _enter_tree():
    assert(owner is Character)
    owner.set_meta(N, self)


func _exit_tree():
    owner.remove_meta(N)


func get_aim_ray() -> RayCast2D:
    return aim


func get_wielded() -> Weapon:
    var weapon = Utils.first(
        owner.get_meta(BodyComponent.N).get_node("wielding")
    )
    # TODO: if empty => fists weapon
    return weapon


## try to store targeted item
func store_targeted():
    var item = reachable_item() as Item
    if item:
        owner.get_meta(BodyComponent.N).store_item(item)


## try to wield targeted weapon, or wear targeted clothing
func equip_targeted():
    var item = reachable_item() as Item
    if item:
        if item is Weapon:
            item.wield(owner)
        elif item is Clothing:
            item.wear(owner)


enum InteractType { EQUIP, STORE }


func reachable_item() -> Item:
    var raycast = RayCast2D.new()
    raycast.collide_with_areas = true
    raycast.hit_from_inside = true
    raycast.position = owner.position + aim.position
    raycast.target_position = aim.target_position
    raycast.set_collision_mask_value(1, false)
    raycast.set_collision_mask_value(3, true)
    get_tree().root.get_node("main").add_child(raycast)
    raycast.force_raycast_update()
    var item = raycast.get_collider() as Item
    raycast.free()

    if item is Item:
        var distance = (item.position - owner.position).length()
        if distance <= REACH_DISTANCE:
            return item
    return null
