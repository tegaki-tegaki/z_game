extends CharacterBody2D
class_name Character

@export var body: BodyComponent
@export var hitbox_component: CollisionShape2D
@export var health_component: HealthComponent
@export var label: Label

var creature: CreatureResource

var MAX_HEALTH: float
var health: float
var speed: float
var stamina = 100
var strength = 10
var is_dead = false


func _ready():
    body.base.texture = creature.sprite
    body.position.y = creature.y_offset
    speed = creature.speed


func load_creature(creature_: CreatureResource):
    creature = creature_
    var textures = G.get_creature_textures(creature_.name)
    creature.sprite = textures.texture
    creature.sprite_corpse = textures.corpse_texture
    MAX_HEALTH = creature_.health
    health = creature_.health
    speed = creature_.speed

    var shape = CircleShape2D.new()
    shape.radius = creature.size
    hitbox_component.shape = shape

    if label:
        label.text = creature.name


## the mass of everything you wear + wield + self
func get_mass() -> float:
    return body.get_mass()


func damage(raw_damage: float, impact_vector: Vector2):
    health_component.damage(raw_damage, impact_vector)


func set_dead():
    is_dead = true
    body.base.texture = creature.sprite_corpse
    body.position.y = creature.corpse_y_offset
    hitbox_component.disabled = true
