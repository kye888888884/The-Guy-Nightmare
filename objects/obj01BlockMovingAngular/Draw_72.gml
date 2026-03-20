dir += spd

if (is_in_camera()) {
    prev_x = x
    prev_y = y

    x = cx + lengthdir_x(dis, dir) + gap_x
    y = cy + lengthdir_y(dis, dir) + gap_y

    coord_on_physics()

    for (var i = 0; i < ds_list_size(objects); i++) {
        var obj = objects[| i]
        obj.id.x = x + obj.xgap
        obj.id.y = y + obj.ygap
        obj.id.depth = depth
    }

    var _hspd = x - prev_x
    var _vspd = y - prev_y
    with (objPlayer) {
        var _oy = vspeed + max(0, _vspd) + 1
        if (other.y > y and place_meeting(x, y + _oy, other)) {
            x += _hspd
            if (_vspd > 0) {
                move_contact(other, 270, abs(_vspd) + 2, 0.1)
            }
            else {
                move_outside(other, 90, abs(_vspd) + 2, 0.1)
            }
        }

        if (other.y < y and place_meeting(x, y - _vspd - 1, other)) {
            if (_vspd > 0) {
                move_outside(other, 270, abs(vspeed) + _vspd + 2, 0.1)
                vspeed = max(vspeed, _vspd)
            }
        }

        var _ox = hspeed
        if (other.x > x and place_meeting(x + hspeed + 1, y, other)) {
            move_outside(other, 180, abs(_hspd) + 3, 0.1)
            // x -= 1
        }
        else if (other.x < x and place_meeting(x + hspeed - 1, y, other)) {
            move_outside(other, 0, abs(_hspd) + 3, 0.1)
            // x += 1
        }

        if (place_meeting(x, y, other)) {
            move_outside(other, 180, 3, 0.1)
            move_outside(other, 0, 3, 0.1)
        }
    }
}