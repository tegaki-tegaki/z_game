extends VBoxContainer

@onready var game_time: Label = %game_time

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
  var wielded = %player.get_node("%wield").get_child(0) as RangedWeapon
  var weapon = wielded.weapon as Weapon
  var ammo = wielded.ammo as Ammo
  game_time.text = "game_time: " + str(T.game_time)
  weapon_stats.text = "weapon (" + weapon.weapon_name + ")"
  aim_spread.text = "aim_spread: " + str(%player.aim_spread)
  aim_time.text = "aim_time: " + str(weapon.aim_time_coefficient)
  fire_time.text = "fire_time: " + str(weapon.fire_time_coefficient)
  ammo_compatible.text = "ammo_compatible: " + str(weapon.compatible_ammo)
  damage.text = "damage estimate (per bullet): " + str(Utils.calc_damage(wielded))
  
  if ammo:
    ammo_texture.texture = ammo.texture
    ammo_stats.text = "ammo (" + ammo.ammo_name + ")"
  else:
    ammo_stats.text = "ammo (NONE)"
  num_ammo.text = "num_ammo: " + str(weapon.num_ammo) + "/" + str(weapon.max_num_ammo)
