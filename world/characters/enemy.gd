class_name Enemy
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = %Sprite2D

var has_target = false
var target: Vector2 = Vector2()
var speed = 65
var health = 1000


func _ready() -> void:
    var player: Player = get_tree().root.get_node("main/%player/%body")
    if player:
        player.player_action.connect(update_ai)


## [code]time_scale[/code] determines velocity
func _physics_process(delta: float) -> void:
    if has_target:
        velocity = target.normalized() * speed * T.time_scale
    else:
        # TODO: something smarter (smells, idle behaviour... stuff)
        velocity = Vector2(randf(), randf()).normalized() * speed * T.time_scale
    if velocity.x > 0:
        sprite_2d.flip_h = false
    else:
        sprite_2d.flip_h = true
    move_and_slide()


func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    has_target = true

func damage(weapon: RangedWeapon, velocity: float):
  var raw_damage = Utils.calc_damage(weapon)
  health -= raw_damage * (velocity / weapon.ammo.bullet_velocity_mps)
  if health <= 0:
    self.queue_free()
