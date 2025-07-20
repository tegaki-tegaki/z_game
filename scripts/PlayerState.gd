class_name PlayerState

enum ActionType { WAIT, MOVE, AIM, FIRE }

var Player: Player
var Action: ActionType

func _init(player: Player, action: ActionType):
  Player = player
  Action = action
