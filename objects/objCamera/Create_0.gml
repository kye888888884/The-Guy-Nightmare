leaveRoom = false // Sets whether the camera can follow the player outside of the room's boundaries
zoom = 1.0
zoom_smooth = zoom
target = objPlayer // The object that the camera will follow
global.cam_x = 0
global.cam_y = 0
global.cam_w = SCREEN_WIDTH
global.cam_h = SCREEN_HEIGHT
cam_x_smooth = 0
cam_y_smooth = 0
cam_speed = 0.2
mode = CAMMODE_AREA

alarm[0] = 1 // initialize camera position on the first step

function update_camera() {
    var _cam_w = SCREEN_WIDTH / zoom
    var _cam_h = SCREEN_HEIGHT / zoom
    global.cam_w = _cam_w
    global.cam_h = _cam_h

    if (instance_exists(target)) {
        var _tx = target.x
        var _ty = target.y
        global.cam_anchor_x = floor(_tx / SCREEN_WIDTH) * SCREEN_WIDTH
        global.cam_anchor_y = floor(_ty / SCREEN_HEIGHT) * SCREEN_HEIGHT
        global.cam_anchor_x = clamp(global.cam_anchor_x, 0, room_width - SCREEN_WIDTH)
        global.cam_anchor_y = clamp(global.cam_anchor_y, 0, room_height - SCREEN_HEIGHT)
        if (mode == CAMMODE_SNAP) {
            cam_x_smooth = floor(_tx / _cam_w) * _cam_w
            cam_y_smooth = floor(_ty / _cam_h) * _cam_h
        }
        else if (mode == CAMMODE_FOLLOW) {
            cam_x_smooth = _tx - _cam_w / 2
            cam_y_smooth = _ty - _cam_h / 2
        }
    }

    cam_x_smooth = clamp(cam_x_smooth, 0, room_width - _cam_w)
    cam_y_smooth = clamp(cam_y_smooth, 0, room_height - _cam_h)
}

function init_camera() {
    update_camera()
    global.cam_x = cam_x_smooth
    global.cam_y = cam_y_smooth
}

function get_camera() {
    return {
        x: global.cam_x,
        y: global.cam_y,
        w: global.cam_w,
        h: global.cam_h
    }
}

function set_camera(_new_mode, _zoom = 1, _cam_speed = 1, _target = objPlayer) {
    mode = _new_mode
    zoom_smooth = _zoom
    cam_speed = _cam_speed
    target = _target
}