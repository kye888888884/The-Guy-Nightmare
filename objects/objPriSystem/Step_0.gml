if (is_restarted()) {
    load()
    with (objPriCircle) { restart() }
}

#region move camera
{
    var _px = global.player_pos.x
    var _py = global.player_pos.y
    var _cx = w / 2
    var _cy = h / 2 + cam_pos_offset_y
    var _tx = _px, _ty = _py

    var _move_x = false, _move_y = false
    if (_px > _cx + cam_x + cam_target_margin) {
        _tx = _px - cam_target_margin - _cx
        _move_x = true
    }
    else if (_px < _cx + cam_x - cam_target_margin) {
        _tx = _px + cam_target_margin - _cx
        _move_x = true
    }

    if (_py > _cy + cam_y + cam_target_margin) {
        _ty = _py - cam_target_margin - _cy
        _move_y = true
    }
    else if (_py < _cy + cam_y - cam_target_margin) {
        _ty = _py + cam_target_margin - _cy
        _move_y = true
    }

    if (_move_x) {
        var _prev_cam_x = cam_x
        cam_x = lerp(cam_x, _tx, 0.15)
        var _dx = cam_x - _prev_cam_x
        moon_mat.rotate(0, -_dx * f_rot, 0)
    }
    if (_move_y) {
        var _prev_cam_y = cam_y
        cam_y = lerp(cam_y, _ty, 0.15)
        var _dy = cam_y - _prev_cam_y
        moon_mat.rotate(_dy * f_rot, 0, 0)
    }

    cam_trans_mat.set_pos(-cam_x, -cam_y - cam_pos_offset_y)
}
#endregion

// if (mouse_wheel_up()) {
//     f_rot += 0.01 * (CTRL ? 0.1 : 1)
//     show_debug_message("f_rot: " + string(f_rot * 100))
// }
// if (mouse_wheel_down()) {
//     f_rot -= 0.01 * (CTRL ? 0.1 : 1)
//     show_debug_message("f_rot: " + string(f_rot * 100))
// }

// manage chunks
var _chunk = new Vec2(floor(cam_x / global.chunk_size), floor(cam_y / global.chunk_size))
if (!_chunk.equals(global.current_chunk)) {
    global.current_chunk = _chunk
    update_chunk()
}