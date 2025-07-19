extends VBoxContainer

@onready var game_time: Label = %game_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
  game_time.text = "game_time: " + str(T.game_time)
