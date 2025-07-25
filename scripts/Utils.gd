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


static func play_shot_sound(node: Node, sound: AudioStream):
    var audioplayer = node.get_node("%audio/gunshot") as AudioStreamPlayer2D
    audioplayer.stream = sound
    audioplayer.play()


static func play_reload_sound(node: Node, sound: AudioStream):
    var audioplayer = node.get_node("%audio/reload") as AudioStreamPlayer2D
    audioplayer.stream = sound
    audioplayer.play()
