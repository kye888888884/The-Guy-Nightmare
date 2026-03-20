/// 

if (left != noone and right != noone) {
    var _green = make_color_rgb(0, 100, 0)
    draw_line_width_color(left.x, y, left.x, left.y, 2, c_gray, _green)
    draw_line_width_color(right.x, y, right.x, right.y, 2, c_gray, _green)
    draw_line_width_color(left.x, y - 4, right.x, y - 4, 2, c_gray, c_gray)

    draw_sprite(sprite_index, 0, left.x + 4, y)
    draw_sprite(sprite_index, 0, right.x - 4, y)
    for (var i = 1; i < up_empty; i++) {
        draw_sprite(sprite_index, 1, left.x + 4, y - i * 32)
        draw_sprite(sprite_index, 1, right.x - 4, y - i * 32)
    }
}