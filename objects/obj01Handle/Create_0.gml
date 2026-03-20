on_handle = false
handle_delay = 0
handle_angle = 0
spin_spd = 2
image_index = 1

function move(_spd) {
    var _spin = true
    with (obj01BlockMoving) {
        if (floor(trg) == other.trg) {
            var _spd1 = _spd * spd
            var _y = clamp(y + _spd1, ystart + min_len, ystart + max_len)
            if (_y == y) {
                _spin = false
            }
            y = _y
        }
    }
    if (_spin)
        handle_angle += _spd * 8
}

function draw() {
    draw_self()
    draw_sprite_ext(sprite_index, 2, x, y, 1, 1, handle_angle, c_white, 1)
}

function draw_player(_x, _y) {
    var _col1 = make_color_rgb(17, 26, 143)
    var _tx = lengthdir_x(8, handle_angle)
    var _ty = lengthdir_y(8, handle_angle)
    draw_line_width_color(_x + 3, _y + 8, _x + _tx, _y + _ty, 3, 0, 0)
    draw_line_width_color(_x + 3, _y + 8, _x + _tx, _y + _ty, 2, _col1, _col1)
    draw_line_width_color(_x - 3, _y + 8, _x + _tx, _y + _ty, 3, 0, 0)
    draw_line_width_color(_x - 3, _y + 8, _x + _tx, _y + _ty, 2, _col1, _col1)
    
    var _col2 = make_color_rgb(255, 199, 143)
    draw_circle_color(_x + _tx, _y + _ty, 1.5, _col2, _col2, false)

    draw_sprite(sprPlayerBack, 0, _x - 16 + 17, _y - 16 + 23)

    with (objPlayer) {
        x = other.x - 16 + 17
        y = other.y - 16 + 23
    }
}