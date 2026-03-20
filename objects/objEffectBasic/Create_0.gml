fade_in = 0.1
fade_out = 0.1
life = 50
xs_spd = 0
ys_spd = 0
sfric = 1
t = 0

col1 = c_white
col2 = c_white

function init(_grav = 0.4, _f_in = 0.1, _f_out = 0.1, _life = 50, _xss = 0, _yss = 0, _col = c_white, _col2 = c_white, _alpha = 1, _sfric = 1) {
    gravity = _grav
    fade_in = _f_in
    fade_out = _f_out
    life = _life
    xs_spd = _xss
    ys_spd = _yss
    col1 = _col
    col2 = _col2
    image_blend = _col
    image_alpha = _alpha
    sfric = _sfric
    return id
}

function sync() {
    x = other.x
    y = other.y
    image_angle = other.image_angle
    image_xscale = other.image_xscale
    image_yscale = other.image_yscale
}