class_name BodyPartData
extends Resource

enum BodyPart { HEAD, EYES, MOUTH, TORSO, ARMS, HANDS, LEGS, FEET }

@export var body_part: BodyPart
@export var coverage: float
@export var protection: float
@export var warmth: float
