for (var i = 0; i < array_length(arr_pos) - 1; i++) {
    var _p1 = arr_pos[i]
    var _p2 = arr_pos[i + 1]
    var _col1 = merge_color(make_color_rgb(0, 150, 0), c_white, i / array_length(arr_pos))
    var _col2 = merge_color(make_color_rgb(0, 150, 0), c_white, (i + 1) / array_length(arr_pos))

    var _alpha = clamp((i + 40) / 10 - 4, 0, 1)
    draw_set_alpha(_alpha)
    draw_line_width_color(_p1.x, _p1.y, _p2.x, _p2.y, 3, _col1, _col2)
}
draw_set_alpha(1)

if (ball_visible) {
    var _shd = shd01Sphere
    shader_set(_shd)
    shader_set_uniform(_shd, "iResolution", [32, 32])
    draw_self()
    shader_reset()
}