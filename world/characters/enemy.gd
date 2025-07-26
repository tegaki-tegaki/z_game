class_name Enemy
extends CharacterBody2D

@onready var sprite_2d: Sprite2D = $Sprite2D
@onready var health_component: HealthComponent = $HealthComponent
@onready var aim_component: RayCast2D = $AimComponent
@onready var wield: Node2D = $wield
@onready var body_component: BodyComponent = $BodyComponent
@onready var hitbox_component: CollisionShape2D = $HitboxComponent

var has_target = false
var target: Vector2 = Vector2()
var speed
var is_dead = false

var player = null

func get_player():
    if !player:
        var _player = get_tree().root.get_node("main/player")
        if _player:
            _player.player_action.connect(update_ai)
            player = _player

func _ready() -> void:
    speed = body_component.creature.speed


## [code]time_scale[/code] determines velocity
func _physics_process(_delta: float) -> void:
    get_player()
    if is_dead:
        return
    if has_target:
        velocity = target.normalized() * speed * T.time_scale
        aim_component.target_position = (
            (target - aim_component.position).normalized() * 50
        )
    else:
        # TODO: something smarter (smells, idle behaviour... stuff)
        velocity = Vector2(randf(), randf()).normalized() * speed * T.time_scale
    move_and_slide()


func damage(raw_damage: float, impact_vector: Vector2):
    health_component.damage(raw_damage, impact_vector)

func set_dead():
    is_dead = true
    body_component.set_dead()
    hitbox_component.disabled = true

func update_ai(player_state: PlayerState):
    # if can see player -> move to
    # if can't see but saw -> move to last seen
    # if at current -> "see" strongest smell trail -> move to
    target = player_state.Player.position - position
    has_target = true
