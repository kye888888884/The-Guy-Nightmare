t += 1

if (t < move_delay - 25) {
    image_yscale += (1 - image_yscale) * 0.2
    image_xscale += (1 - image_xscale) * 0.2
}

if (t > move_delay - 25 and t < move_delay) {
    var _t = ((t - (move_delay - 25)) / 25) // 0 ~ 1
    move_shake = _t * 8
    image_yscale = 1 + _t * 0.5
    image_xscale = 1 - _t * 0.5
}

if (t == move_delay) {
    prev_x = x
    prev_y = y
    move_shake = 0
}

if (t >= move_delay) {
    var _move_x = lengthdir_x(move_len, move_dir)
    var _move_y = lengthdir_y(move_len, move_dir)
    move_t += move_speed

    var _spd = max(move_speed * move_len / 10, 0.5)

    image_yscale += (1 - 0.7 * _spd - image_yscale) * 0.2
    image_xscale += (2 * _spd - image_xscale) * 0.2

    x = lerp(prev_x, prev_x + _move_x, move_t)
    y = lerp(prev_y, prev_y + _move_y, move_t)

    if (move_t >= 1) {
        x = prev_x + _move_x
        y = prev_y + _move_y
        move_t = 0
        t = 0
        move_dir += move_add_angle
        image_angle += move_add_angle
        prev_x = x
        prev_y = y
    }
}

if (place_meeting(x, y, objPlayer)) {
    with (objPlayer) { scrKillPlayer() }
}