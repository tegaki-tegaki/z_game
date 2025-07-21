extends VBoxContainer

@onready var game_time: Label = %game_time

@onready var weapon_stats: Label = %weapon_stats
@onready var aim_spread: Label = %aim_spread
@onready var aim_time: Label = %aim_time
@onready var fire_time: Label = %fire_time
@onready var damage: Label = %damage

@onready var ammo_stats: Label = %ammo_stats
@onready var ammo_compatible: Label = %ammo_compatible
@onready var ammo_loaded: Label = %ammo_loaded
@onready var num_ammo_loaded: Label = %num_ammo_loaded
@onready var ammo_texture: TextureRect = %ammo_texture

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  var weapon = %player.get_node("%wield").get_child(0) as WeaponComponent
  var ammo = weapon.get_node("%ammo").get_child(0) as AmmoComponent
  game_time.text = "game_time: " + str(T.game_time)
  weapon_stats.text = "weapon (" + weapon.weapon_name + ")"
  aim_spread.text = "aim_spread: " + str(%player.aim_spread)
  aim_time.text = "aim_time: " + str(weapon.aim_time_coefficient)
  fire_time.text = "fire_time: " + str(weapon.fire_time_coefficient)
  ammo_compatible.text = "ammo_compatible: " + str(weapon.compatible_ammo)
  damage.text = "damage estimate (per bullet): " + str(Utils.calc_damage(weapon))
  
  if ammo:
    ammo_texture.texture = ammo.get_node("%sprite").texture
    ammo_stats.text = "ammo (" + ammo.name + ")"
    ammo_loaded.text = "ammo_loaded: " + str(ammo.name)
  else:
    ammo_stats.text = "ammo (NONE)"
    ammo_loaded.text = "ammo_loaded: NONE"
  num_ammo_loaded.text = "num_ammo_loaded: " + str(weapon.num_ammo)
