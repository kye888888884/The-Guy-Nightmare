function copy() {
    return vec2(x, y)
}

function dot(_x, _y = undefined) {
    if (_y == undefined) {
        var _result = x * _x.x + y * _x.y
        return _result
    } else {
        return x * _x + y * _y
    }
}

function equals(_x, _y = undefined) {
    if (_y == undefined) {
        return x == _x.x and y == _x.y
    } else {
        return x == _x and y == _y
    }
}

function add(_x, _y = undefined) {
    if (_y == undefined) {
        x += _x.x
        y += _x.y
    } else {
        x += _x
        y += _y
    }
    return id
}

function mul(_len) {
    x *= _len
    y *= _len
    return id
}

function len() {
    return point_distance(0, 0, x, y)
}

function dir() {
    return point_direction(0, 0, x, y)
}

function rot(_angle) {
    var _len = len()
    var _dir = dir() + _angle
    x = lengthdir_x(_len, _dir)
    y = lengthdir_y(_len, _dir)
    return id
}

function normalize() {
    var _len = len()
    if (_len != 0) {
        x /= _len
        y /= _len
    }
    return id
}

function str() {
    return "(" + string(x) + ", " + string(y) + ")"
}

function free() {
    instance_destroy(id)
}