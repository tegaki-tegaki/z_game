class_name Utils


static func load_json_file(filename: String):
    var file_json = FileAccess.get_file_as_string(filename)
    var config = JSON.parse_string(file_json)

    if config:
        return config


static func kinetic_energy(ammo: AmmoResource, bullet_velocity: float):
    return 0.5 * ammo.bullet_mass_kg * (bullet_velocity ** 2)


static func get_raycast_colliders(raycast: RayCast2D):
    var colliders = []
    raycast.force_raycast_update()
    while raycast.is_colliding():
        var collider = raycast.get_collider()
        colliders.append(collider)
        raycast.add_exception(collider)
        raycast.force_raycast_update()
    return colliders


static func play_sound(node: AudioStreamPlayer2D, sound: AudioStream):
    node.stream = sound
    node.play()


## [param items] must be like this: [ [item, weight], [item, weight] ]
static func weighted_random_pick(items: Array):
    var total_weight = 0.0
    for item in items:
        total_weight += item[1]

    var random_value = randf() * total_weight
    var cumulative = 0.0

    for item in items:
        cumulative += item[1]
        if random_value < cumulative:
            return item[0]

    return items[-1][0]  # Fallback


## returns a random unit vector
static func rand_Vector2() -> Vector2:
    var angle = randf() * TAU
    return Vector2(cos(angle), sin(angle))


## "safe" [code]get_child(0)[/code] , ie. doesn't throw error
static func first(node: Node):
    if node.get_child_count():
        return node.get_child(0)
    return null
