image_index = 2
size = 0
_sizes = [30, 45, 64, 96]
sprites = [spr01MelonGameObjectsSize1, spr01MelonGameObjectsSize2, spr01MelonGameObjectsSize3, spr01MelonGameObjectsSize4]
size_change = false
size_t = 0
mask_scale = 30 / 96
draw_scale = 1
ready = false

ins_mask = instance_create(obj01MelonGameObjectMask, x, y)
ins_mask.anchor = id
meet_list = ds_list_create()

colors = [make_color_rgb(66, 193, 14), make_color_rgb(255, 192, 0), make_color_rgb(250, 140, 58), make_color_rgb(226, 81, 98)]

depth -= 15

fix_id = -1

function init() {
    var _s = _sizes[size] / 96

    var _fix = get_fixture(_s)
    fix_id = physics_fixture_bind(_fix, id)
    physics_fixture_delete(_fix)
}

function get_fixture(_s) {
    var _den = 1
    var _res = 0.5
    var _fric = 0.5
    var _damp = 1.0

    var _fix
    if (image_index == 0) {
        _fix = physics_fixture_create()
        physics_fixture_set_polygon_shape(_fix)
        physics_fixture_add_point(_fix, 0, -40 * _s)
        physics_fixture_add_point(_fix, 41 * _s, 40 * _s)
        physics_fixture_add_point(_fix, -41 * _s, 40 * _s)
        physics_fixture_set_density(_fix, _den)
        physics_fixture_set_restitution(_fix, _res)
        physics_fixture_set_friction(_fix, _fric)
        physics_fixture_set_linear_damping(_fix, _damp)
        physics_fixture_set_angular_damping(_fix, 0)
    }
    else if (image_index == 1) {
        _fix = fixture_create_circle(41 * _s, _den, _res, _fric, _damp, 0)
    }
    else if (image_index == 2) {
        _fix = fixture_create_box(80 * _s, 80 * _s, _den, _res, _fric, _damp, 0)
    }
    return _fix
}

function size_up() {
    ready = true
    size += 1
    with (obj01MelonGame) { score_up(other.size) }
    size_change = true
    sprite_index = sprites[size]
    create_effect(size)
}

function create_effect(_s) {
    for (var i = 0; i < 3 + _s * 2; i++) {
        effect_create(EF_RING, 2, x, y, depth - 10, 0, 0, 0, 0, 0)
        .init(0, 0, 0.05, 30, 0.05 + 0.01 * i, 0.05 + 0.01 * i, c_white, colors[_s], 1, 0.95)
    }
}