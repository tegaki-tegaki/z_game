class_name AimComponent
extends RayCast2D

const N = &"AimComponent"


func _enter_tree():
    assert(owner is Character)
    owner.set_meta(N, self)


func _exit_tree():
    owner.remove_meta(N)
