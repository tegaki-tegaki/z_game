class_name Player
extends CharacterBody2D

@onready var skin: Sprite2D = %skin

signal player_action(player)


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
    pass  # Replace with function body.


var speed = 60
var can_act = true


func act(delta, action_type: PlayerState.ActionType):
    T.update(delta)
    player_action.emit(PlayerState.new(self, action_type))


func _physics_process(delta):
    if can_act:
        handle_actions(delta)
    else:
        act(delta, PlayerState.ActionType.WAIT)
    aim_marker()


func handle_actions(delta):
    if handle_move(delta):
        return
    if handle_aim(delta):
        return
    if handle_fire(delta):
        return
    if handle_reload(delta):
        return


var is_aiming = false
var aim_spread := PI
var aim_direction: Vector2


func handle_move(delta):
    var input_vector = Input.get_vector(
        "move_left", "move_right", "move_up", "move_down"
    )

    if input_vector.length() > 0:
        velocity = input_vector * speed
        if velocity.x > 0:
            transform.x = Vector2(1.0, 0.0)
        elif velocity.x < 0:
            transform.x = Vector2(-1.0, 0.0)
        move_and_slide()

        if is_aiming:
            is_aiming = false
        aim_spread = PI
        act(delta, PlayerState.ActionType.MOVE)

        return true


func handle_aim(delta):
    var attempt_aim = Input.is_action_pressed("aim_weapon")
    if attempt_aim:
        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon
        act(delta, PlayerState.ActionType.AIM)

        if !is_aiming:
            is_aiming = true
            aim_spread = weapon.start_aim_spread

        aim_spread = move_toward(
            aim_spread,
            weapon.best_aim_spread,
            delta * weapon.aim_time_coefficient
        )

        return true
    return false


func handle_fire(delta):
    var attempt_fire = Input.is_action_just_pressed("fire_weapon")
    if attempt_fire:
        disable_act(0.2)
        act(delta, PlayerState.ActionType.FIRE)
        
        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon as Weapon
        var ammo = wielded.ammo as Ammo
        
        if ammo && weapon.num_ammo:
          # play fire sound
          fire_ammo(ammo)
          weapon.num_ammo -= 1
          if weapon.num_ammo <= 0:
            wielded.ammo = null
        else:
          # play click sound
          pass

        return true
    return false
    
func fire_ammo(ammo: Ammo):
  for i in ammo.num_bullets:
    var raycast = RayCast2D.new()
    var aim_target = %aim_marker.get_node("raycast").target_position as Vector2
    var random_spread = randf_range(-aim_spread/2, aim_spread/2)
    raycast.position = %body.position + %aim_marker.position
    raycast.target_position = (aim_target.normalized()).rotated(random_spread)
    raycast.target_position *= 800 # use bullet / gun range?
    raycast.set_collision_mask_value(2, true)
    raycast.hit_from_inside = true
    get_tree().root.get_node("main/%bullets").add_child(raycast)
  calculate_bullet_hits()
  
func calculate_bullet_hits():
  var wielded = %wield.get_child(0) as RangedWeapon
  var weapon = wielded.weapon as Weapon
  var ammo = wielded.ammo as Ammo
  var bullets = get_tree().root.get_node("main/%bullets")
  
  for bullet: RayCast2D in bullets.get_children():
    var hits = Utils.get_raycast_colliders(bullet)
    print("bullet " + bullet.name + " hit " + str(hits))
    var velocity = ammo.bullet_velocity_mps
    for hit: Enemy in hits:
      hit.damage(wielded, velocity)
      velocity -= 100 # TODO: something smarter
    bullet.queue_free()

func handle_reload(delta):
    var attempt_reload = Input.is_action_just_pressed("reload_weapon")
    if attempt_reload:
        disable_act(2)
        act(delta, PlayerState.ActionType.RELOAD)
        var wielded = %wield.get_child(0) as RangedWeapon
        var weapon = wielded.weapon as Weapon

        const _00_SHOT = preload("res://resources/ammo/00_shot.tres")
        wielded.ammo = _00_SHOT
        weapon.num_ammo = 2

        return true
    return false


func aim_marker():
    var raycast = %aim_marker.get_node("raycast")
    raycast.position = %body.position
    raycast.target_position = get_global_mouse_position() - (raycast.position + %aim_marker.position)


func disable_act(duration_seconds: float):
    var disable_act_timer = get_tree().create_timer(duration_seconds)
    disable_act_timer.timeout.connect(enable_act)
    can_act = false


func enable_act():
    can_act = true
