extends RefCounted

class_name Dict

var _bucket_count := 16
var _buckets := []
var _size := 0
var _load_factor := 0.75


func _init():
    _clear_buckets()


func _clear_buckets():
    _buckets = []
    for i in range(_bucket_count):
        _buckets.append([])


func _hash(key) -> int:
    # Simple hash function (could be improved)
    var h = int(hash(key))
    return abs(h) % _bucket_count


@warning_ignore("native_method_override")
func set(key, value):
    if _size + 1 > int(_bucket_count * _load_factor):
        _resize()

    var index = _hash(key)
    var bucket = _buckets[index]

    for entry in bucket:
        if entry.key == key:
            entry.value = value
            return

    bucket.append(Entry.new(key, value))
    _size += 1


@warning_ignore("native_method_override")
func get(key, default_value = null):
    var index = _hash(key)
    var bucket = _buckets[index]

    for entry in bucket:
        if entry.key == key:
            return entry.value

    return default_value


func has(key) -> bool:
    var index = _hash(key)
    for entry in _buckets[index]:
        if entry.key == key:
            return true
    return false


func erase(key):
    var index = _hash(key)
    var bucket = _buckets[index]
    for i in range(bucket.size()):
        if bucket[i].key == key:
            bucket.remove_at(i)
            _size -= 1
            return


func size() -> int:
    return _size


func keys() -> Array:
    var result = []
    for bucket in _buckets:
        for entry in bucket:
            result.append(entry.key)
    return result


func values() -> Array:
    var result = []
    for bucket in _buckets:
        for entry in bucket:
            result.append(entry.value)
    return result


func _resize():
    var old_buckets = _buckets.duplicate(true)
    _bucket_count *= 2
    _clear_buckets()
    _size = 0

    for bucket in old_buckets:
        for entry in bucket:
            set(entry.key, entry.value)


class Entry:
    var key
    var value

    func _init(_key, _value):
        key = _key
        value = _value
