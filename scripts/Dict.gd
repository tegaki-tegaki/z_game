extends Node
class_name Dict

var _entries := []

func s(key, value):
    for i in range(_entries.size()):
        if _entries[i][0] == key:
            _entries[i][1] = value
            return
    _entries.append([key, value])

func g(key):
    for entry in _entries:
        if entry[0] == key:
            return entry[1]
    return null

func has(key):
    for entry in _entries:
        if entry[0] == key:
            return true
    return false

func erase(key):
    for i in range(_entries.size()):
        if _entries[i][0] == key:
            _entries.remove_at(i)
            return

func keys():
    var result := []
    for entry in _entries:
        result.append(entry[0])
    return result

func values():
    var result := []
    for entry in _entries:
        result.append(entry[1])
    return result

func clear():
    _entries.clear()
