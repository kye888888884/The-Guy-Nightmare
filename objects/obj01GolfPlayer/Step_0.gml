if (y > SCREEN_HEIGHT) {
    with (objPlayer) {
        x = other.x
        y = other.y
        scrKillPlayer()
    }
    ball_visible = false
    window_set_cursor(cr_default)
    window_mouse_set(start_mx, start_my)
}

if (ball_visible) {
    if (mouse_check_button_pressed(mb_left)) {
        prev_mx = mouse_x
        prev_my = mouse_y
        shot_t = 0
        dx = 0
        dy = 0
    }

    // window_set_cursor(cr_none)

    var _sw = SCREEN_WIDTH * 0.5
    var _sh = SCREEN_HEIGHT * 0.5

    if (mouse_check_button(mb_left)) {
        var _dx = 0, _dy = 0
        var _mx = window_mouse_get_x()
        var _my = window_mouse_get_y()
        if (_mx != _sw or _my != _sh) {
            _dx = _mx - _sw
            _dy = _my - _sh
        }
        // show_debug_message(string(_dx) + ", " + string(_dy))
        
        dx += _dx
        dy += _dy
        var _dis = point_distance(0, 0, dx, dy)
        var _dir = point_direction(0, 0, dx, dy)
        _dis = min(64, _dis)
        dx = lengthdir_x(_dis, _dir)
        dy = lengthdir_y(_dis, _dir)
        
        draw_x = lengthdir_x(_dis, _dir)
        draw_y = lengthdir_y(_dis, _dir)
        
        var _shot_power_max = (_dis / 64)
        shot_t = min(1, shot_t + 0.04 / (shot_count))
        shot_power = lerp(0, _shot_power_max, shot_t)
    }

    window_mouse_set(_sw, _sh)

    if (mouse_check_button_released(mb_left)) {
        if (!frozen) {
            if (shot_power > 0.1) {
                shot_count += 1
                var _power = sqrt(shot_power) * 0.4
                physics_apply_impulse(x, y, -draw_x * _power, -draw_y * _power)
                alarm[0] = 10
            }
            dx = 0
            dy = 0
        }
    }

    if (place_meeting(x + phy_speed_x, y + phy_speed_y + 1, obj01PhysicsBlock)) {
        if (shot) {
            frozen = true
            shot_count = 1
        }
        if (abs(phy_speed_x) < 0.04 && abs(phy_speed_y) < 0.04) {
            phy_speed_x = 0
            phy_speed_y = 0
            frozen_t = min(1, frozen_t + 0.1)
            if (frozen_t >= 1) {
                shot = false
                frozen = false
                shot_count = 0
            }
        }
        else {
            frozen_t = 0
            var _y = y
            while (!physics_test_overlap(x, _y, image_angle, obj01PhysicsBlock) and _y < y + 1) {
                _y += 0.1
            }
            phy_position_y = _y
            // phy_angular_velocity *= 0.9
        }
    }

    image_blend = frozen ? c_gray : c_white
}

array_push(arr_pos, {x: x, y: y})
if (array_length(arr_pos) > 50) {
    array_shift(arr_pos)
}

if (!ball_visible) {
    phy_speed_x = 0
    phy_speed_y = 0
}