extends Node
class_name InteractionComponent

@onready var parent: Character = $".."
@export var aim: AimComponent

var aim_spread: float


func get_aim_ray() -> RayCast2D:
    return aim


func get_wielded() -> Weapon:
    var weapon = Utils.first(
        get_parent().get_node("BodyComponent/wielding")
    )
    # TODO: if empty => fists weapon
    return weapon


func set_wielded(weapon: Weapon):
    parent.get_node("BodyComponent/wielding").add_child(weapon)
    weapon.wield(parent)


func wear_targeted():
    var debug_target = get_tree().root.get_node("main/debug_target")
    var target = Vector2(
        parent.position + (aim.target_position + aim.position)
    )
    debug_target.position = target

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
    raycast.free()

    if item && item is Item:
        var distance = (parent.position - item.position).length()
        if distance < 20:
            item.wear(parent)
