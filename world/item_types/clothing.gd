class_name Clothing
extends Item

var storage_used: float


func _ready():
    super._ready()
    storage_used = 0.0


func load_clothing(clothing: ItemResource):
    super.load_item(clothing)
