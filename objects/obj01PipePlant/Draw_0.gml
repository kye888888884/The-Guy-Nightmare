var _get_pos = function (_t, _gt) { 
    var _h = 32 * image_yscale
    var _ybottom = y + _h / 2
    return get_bezier(_t,
        x + 32 * _gt * sin(get_time() * 2),
        _ybottom - _h * (1 - _gt * 0.2 * (1 + 0.2 * sin(get_time()))),
        x + 24 * _gt * sin(get_time() * 1.5 + 3.14),
        _ybottom - 0.66 * _h * (1 - _gt * 0.2 * (1 + 0.2 * sin(get_time() * 1.5))),
        x + 32 * _gt * sin(get_time()),
        _ybottom - 0.33 * _h * (1 - _gt * 0.2),
        x, _ybottom
    )
}

var _global_t = clamp(t / 150, 0, 1)
_global_t = curve_value(ac01, "trg9_gt", _global_t)
for (var _v = 0; _v < image_yscale; _v += 0.5) {
    var _t = clamp(t / 50 + _v / image_yscale - 1, 0, 1)
    var _tc = curve_value(ac01, "trg9", _t)

    var _pos1 = _get_pos((_v + 1) / image_yscale, _global_t)
    var _pos2 = _get_pos((_v + 2) / image_yscale, _global_t)
    var _rot = point_direction(_pos1.x, _pos1.y, _pos2.x, _pos2.y) - 270

    var _col1 = merge_color(c_black, make_color_rgb(0, 100, 0), _v / image_yscale)
    var _col2 = merge_color(c_black, make_color_rgb(0, 100, 0), (_v + 1) / image_yscale)

    draw_line_width_color(_pos1.x - 1, _pos1.y, _pos2.x - 1, _pos2.y, 4, _col1, _col2)

    for (var _h = -1; _h <= 1; _h += 2) {

        var _xs = -_h
        var _ys = 1 + _t * curve_value(ac01, "trg9_1", _v / image_yscale)

        var _index = floor(_t * 13)
        var _angle = -_h * _tc * (t2 + 0.05 * sin((_h * _v) * 123.456 + get_time())) * 75 + _rot * 1.5

        draw_sprite_ext(spr01PipePlantL, _index, _pos1.x, _pos1.y, _xs, _ys, _angle, c_white, 1)
    }
}

t += 1
t2 += (1 - t2) * 0.02