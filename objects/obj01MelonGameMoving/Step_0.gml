if (target != noone) {
    var _tx = lerp(curve_value(ac01, "melon1", t), curve_value(ac01, "melon2", t), lx)
    var _ty = lerp(curve_value(ac01, "melon1", t), curve_value(ac01, "melon2", t), ly)

    var _x = lerp(xstart, target.x, _tx)
    var _y = lerp(ystart, target.y, _ty)

    var _scale = lerp(1, 1.5, curve_value(ac01, "melon_scale", t))

    image_angle += 10 * curve_value(ac01, "melon_scale", t)
    image_xscale = _scale
    image_yscale = _scale
    x = _x
    y = _y

    var _e_scale = _scale * (_sizes[size] / 96) * 0.8
    // effect_create(spr01MelonGameObjectsWhite, image_index, x, y, depth + 15, _e_scale, _e_scale, 0, 0, image_angle).init(0, 0, 0.1, 10, 0.02, 0.02, colors[size], colors[size], 1)
    var _dist = point_distance(xprevious, yprevious, x, y)
    var _ang = point_direction(xprevious, yprevious, x, y)
    part_type_orientation(pt.t, image_angle, image_angle, 0, 0, false)
    for (var i = 0; i < _dist; i++) {
        var _x = xprevious + lengthdir_x(i, _ang)
        var _y = yprevious + lengthdir_y(i, _ang)
        particle_emit(pt, _x, _y, 1)
    }

    t = min(1, t + 0.05)

    if (t == 1) {
        with (target) size_up()
        target = noone
        visible = false
        alarm[1] = 50
    }
}