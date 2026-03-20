if (on_move) {
    var _dis = point_distance(cx, cy, sx, sy)
    var _dir = point_direction(cx, cy, sx, sy)

    move_t = min(move_t + 0.02, 1)

    x = cx + lengthdir_x(_dis, _dir + move_t * 180)
    y = cy + lengthdir_y(_dis, _dir + move_t * 180)
    image_angle = sangle + move_t * 180

    if (move_t >= 1) {
        on_move = false
        move_t = 0
    }
}

// if (!on_move) {
//     if (keyboard_check_pressed(ord("A"))) move_left()
//     if (keyboard_check_pressed(ord("D"))) move_right()
// }