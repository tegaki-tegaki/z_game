extends MarginContainer


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
    if Input.is_action_just_pressed("ui_cancel"):
        visible = !visible
    if Input.is_action_just_pressed("ui_help"):
        visible = true
    
