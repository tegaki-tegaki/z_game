extends Node2D

var aim_component: AimComponent
var interact: InteractionComponent


func _ready() -> void:
    interact = owner.get_meta(InteractionComponent.N) as InteractionComponent
    aim_component = owner.get_meta(AimComponent.N) as AimComponent


func _process(delta: float) -> void:
    queue_redraw()  # PERF: could avoid redraw if mouse not moved


func _draw():
    var _owner = owner as Player
    if !_owner.mode == Player.Mode.AIMING:
        return
        
    var aim_spread_mod = inverse_lerp(0, TAU, interact.aim_spread)

    var screen_dim = get_viewport().size
    var aim_angle = aim_component.position.angle_to(aim_component.target_position) + PI/2
    var start_angle =  (aim_angle + (PI - interact.aim_spread/2))
    var stop_angle = (aim_angle - (PI - interact.aim_spread/2))
    draw_ring_arc(
        position + aim_component.position,
        2500.0,
        clamp(
            lerpf(0, 1000, aim_spread_mod), 
            50, 400),
        start_angle,
        stop_angle,
        Color(0, 0, 0, 0.2),
    )
    
func draw_filled_arc(center: Vector2, radius: float, start_angle: float, end_angle: float, color: Color, segments: int = 32):
    var points = PackedVector2Array()
    
    # Center point
    points.append(center)
    
    # Arc points
    var angle_step = (end_angle - start_angle) / segments
    for i in range(segments + 1):
        var angle = start_angle + i * angle_step
        var point = center + Vector2(cos(angle), sin(angle)) * radius
        points.append(point)
    
    # Draw triangles
    for i in range(segments):
        var triangle_points = PackedVector2Array([points[0], points[i + 1], points[i + 2]])
        draw_colored_polygon(triangle_points, color)

func draw_ring_arc(center: Vector2, outer_radius: float, inner_radius: float, start_angle: float, end_angle: float, color: Color, segments: int = 32):
    var points = PackedVector2Array()
    
    var angle_step = (end_angle - start_angle) / segments
    
    # Outer arc points (clockwise)
    for i in range(segments + 1):
        var angle = start_angle + i * angle_step
        points.append(center + Vector2(cos(angle), sin(angle)) * outer_radius)
    
    # Inner arc points (counter-clockwise to create hole)
    for i in range(segments, -1, -1):
        var angle = start_angle + i * angle_step
        points.append(center + Vector2(cos(angle), sin(angle)) * inner_radius)
    
    draw_colored_polygon(points, color)
