if (on_rotate) {
    var _dis = point_distance(cx, cy, sx, sy)
    var _dir = point_direction(cx, cy, sx, sy)

    rot_t = min(rot_t + 0.02, 1)

    x = cx + lengthdir_x(_dis, _dir + rot_t * 180)
    y = cy + lengthdir_y(_dis, _dir + rot_t * 180)
    image_angle = rot_t * 180

    if (rot_t >= 1) {
        on_rotate = false
        rot_t = 0
        image_index = new_index
        image_angle = 0
        if (new_plate != -1) plate = new_plate
    }
}