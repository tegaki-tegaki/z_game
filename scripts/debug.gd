extends VBoxContainer

@onready var weapon_stats: Label = %weapon_stats
@onready var aim_spread: Label = %aim_spread
@onready var aim_time: Label = %aim_time
@onready var fire_time: Label = %fire_time
@onready var damage: Label = %damage

@onready var ammo_stats: Label = %ammo_stats
@onready var ammo_compatible: Label = %ammo_compatible
@onready var num_ammo: Label = %num_ammo
@onready var ammo_texture: TextureRect = %ammo_texture


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    var combat = %player.combat
    var wielded = combat.get_wielded() as WieldedWeapon
    var weapon = wielded.get_weapon()
    
    if weapon is RangedWeaponResource:
        var ammo = wielded.loaded_ammo as AmmoResource
        var player = %player.get_node("%body") as Player
        weapon_stats.text = "weapon (" + weapon.weapon_name + ")"
        aim_spread.text = "aim_spread: " + str(combat.aim_spread)
        aim_time.text = "aim_time: " + str(weapon.aim_time_modifier)
        fire_time.text = "attack_time: " + str(weapon.attack_time_modifier)
        ammo_compatible.text = (
            "ammo_compatible: " + str(AmmoResource.AmmoType.keys()[weapon.compatible_ammo])
        )
        damage.text = (
            "damage estimate (per bullet): " + str(Combat.calc_damage(wielded))
        )

        if ammo:
            ammo_texture.texture = ammo.texture
            ammo_stats.text = "ammo (" + ammo.ammo_name + ")"
        else:
            ammo_texture.texture = null
            ammo_stats.text = "ammo (NONE)"
        num_ammo.text = (
            "num_ammo: " + str(wielded.loaded_ammo_num) + "/" + str(weapon.max_num_ammo)
        )
    if weapon is MeleeWeaponResource:
        pass
