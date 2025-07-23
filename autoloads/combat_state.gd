extends Node

@onready var bullets = get_tree().root.get_node("main/%bullets/raycasts")
@onready var bullet_decals = get_tree().root.get_node("main/%bullets/decals")

func render_bullet(bullet_ray: RayCast2D, terminal_collider: CharacterBody2D):
    var origin_point = bullet_ray.position
    var end_point = origin_point + bullet_ray.target_position
    if terminal_collider:
        bullet_ray.force_raycast_update()
        end_point = bullet_ray.get_collision_point()
    var line = Line2D.new()

    line.width = 0.5
    line.default_color = Color(1.0, 1.0, 0.6)
    line.add_point(origin_point)
    line.add_point(end_point)

    C.bullet_decals.add_child(line)

    var tween = get_tree().create_tween()  # PERF: tween per bullet
    tween.parallel().tween_property(line, "modulate", Color.TRANSPARENT, 0.75)
    tween.parallel().tween_property(line, "width", 5.0, 0.75)
    tween.tween_callback(line.queue_free)
