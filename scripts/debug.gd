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
@onready var fps: Label = %FPS
@onready var position_: Label = %position
@onready var stamina: Label = %stamina
@onready var mass: Label = %mass
@onready var storage: Label = %storage


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
    fps.text = "FPS: %s" % [Engine.get_frames_per_second()]
    var player = get_tree().root.get_node("main/player") as Node2D
    if player:
        position_.text = "position: %s" % [player.position]
        stamina.text = "stamina: %s" % [player.stamina]
        storage.text = (
            "storage: %s / %s cm3"
            % [player.get_used_storage(), player.get_storage()]
        )
        mass.text = "mass: %s kg" % [player.get_mass()]
        var interact = player.interact
        var wielded = interact.get_wielded() as Weapon
        if wielded:
            var weapon = wielded.get_weapon()

            if weapon is RangedWeaponResource:
                var ammo = wielded.loaded_ammo as AmmoResource
                weapon_stats.text = "weapon (" + weapon.name + ")"
                aim_spread.text = "aim_spread: " + str(interact.aim_spread)
                aim_time.text = (
                    "aim_time: " + str(weapon.aim_time_modifier)
                )
                fire_time.text = (
                    "attack_time: "
                    + str(weapon.weapon_data.attack_time_modifier)
                )
                ammo_compatible.text = (
                    "ammo_compatible: "
                    + str(
                        AmmoResource.AmmoType.keys()[
                            weapon.compatible_ammo
                        ]
                    )
                )
                damage.text = (
                    "damage estimate (per bullet): "
                    + str(C.calc_damage(C.DamageCalcData.new(wielded)))
                )

                if ammo:
                    ammo_texture.texture = ammo.texture
                    ammo_stats.text = "ammo (" + ammo.ammo_name + ")"
                else:
                    ammo_texture.texture = null
                    ammo_stats.text = "ammo (NONE)"
                num_ammo.text = (
                    "num_ammo: "
                    + str(wielded.loaded_ammo_num)
                    + "/"
                    + str(weapon.max_num_ammo)
                )
            if weapon is MeleeWeaponResource:
                pass
