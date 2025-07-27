extends Resource
class_name BodyPartData

enum BodyPart { HEAD, EYES, MOUTH, TORSO, ARMS, HANDS, LEGS, FEET }

@export var body_part: BodyPart
@export var coverage: float
@export var protection: float
@export var warmth: float
