x = 0
y = 0
z = 0
rx = 0
ry = 0
rz = 0
sx = 1
sy = 1
sz = 1

mat = matrix_build_identity()

function init(_x, _y, _z, _rx, _ry, _rz, _sx, _sy, _sz) {
    x = _x
    y = _y
    z = _z
    rx = _rx
    ry = _ry
    rz = _rz
    sx = _sx
    sy = _sy
    sz = _sz

    update()

    return id
}

function update() {
    mat = matrix_build(x, y, z, rx, ry, rz, sx, sy, sz)

    return id
}

function set_pos(_x, _y, _z) {
    x = _x
    y = _y
    z = _z

    update()

    return id
}

function set_rotation(_rx, _ry, _rz) {
    rx = _rx
    ry = _ry
    rz = _rz

    update()

    return id
}

function set_scale(_sx, _sy, _sz) {
    sx = _sx
    sy = _sy
    sz = _sz

    update()

    return id
}

function get_pos_on_matrix(_x, _y, _z) {
    return pos_on_matrix(mat, _x, _y, _z)
}

function multiply(_m, _adjust = false) {
    if (_adjust) {
        mat = matrix_multiply(mat, _m)
        return id
    } else {
        return matrix_multiply(mat, _m)
    }
}

function move(_dx, _dy, _dz) {
    x += _dx
    y += _dy
    z += _dz

    update()

    return id
}

function rotate(_drx, _dry, _drz) {
    var _m = matrix_build(0, 0, 0, _drx, _dry, _drz, 1, 1, 1)
    mat = matrix_multiply(mat, _m)

    return id
}

function matrix() {
    return mat
}

function free() {
    instance_destroy()
}