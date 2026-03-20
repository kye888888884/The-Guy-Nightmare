update_surface()

var _gb = (0.5 + 0.5 * dsin(red_t)) * 255
draw_surface_ext(surf_red, 5184, 96, 1, 1, 0, make_color_rgb(255, _gb, _gb), 1)

var _red_spd = 10
ds_list_clear(red_list)
for (var _y = 96; _y <= 272; _y += 32) {
    var _col = collision_line_list(5184, _y, 5408, _y, obj01MelonGameObject, true, true, red_list, false)

    var _is_col = false
    for (var i = 0; i < ds_list_size(red_list); i++) {
        var _ins = ds_list_find_value(red_list, i)
        if (_ins.ready) {
            _is_col = true
            break
        }
    }
    if (!_is_col) _red_spd -= 1.5
    else {
        if (_y == 96)
            gameover = true
        break
    }
}
red_t += _red_spd

if (instance_exists(objPlayer)) {
    var _x = objPlayer.x
    _x = clamp(_x, 5200, 5392)
    if (create_delay == 0) {
        draw_sprite(spr01MelonGameObjectsSize1, current_object_index, _x, 64)
        draw_surface(surf_line, _x - 2, 80)
    }
}