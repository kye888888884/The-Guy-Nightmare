for (var i = 0; i < image_xscale; i++) {
    for (var j = 0; j < image_yscale; j++) {
        var _x = i * 32
        var _y = j * 32
        var _dis = point_distance(0, 0, _x, _y)
        var _dir = point_direction(0, 0, _x, _y)
        var _x2 = lengthdir_x(_dis, _dir + image_angle)
        var _y2 = lengthdir_y(_dis, _dir + image_angle)

        var _index = (frac(sin(_x * 432 + _y * 123)) > 0.5) + 1
        if (glow and j == image_yscale - 1) _index += 2
        
        draw_sprite_ext(spr01Block, _index, x + _x2, y + _y2, 1, 1, image_angle, image_blend, image_alpha)
    }
}

if (is_triggered) {
    if (trg == 2) {
        with (objPlayer) {
            if (place_meeting(x, y + other.vspeed + vspeed + 1, other)) {
                vspeed = max(vspeed, other.vspeed)
                move_contact_solid(270, abs(other.vspeed + 2))
                on_block = true
            }
        }
    }
}