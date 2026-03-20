if (mode != CAMMODE_AREA)
    update_camera()

var _cam = noone
with (objCameraTouchArea) {
    if (place_meeting(x, y, objPlayer)) {
        _cam = get_cam()
    }
}

if (_cam != noone) {
    cam_x_smooth = _cam.x
    cam_y_smooth = _cam.y
    zoom_smooth = min(SCREEN_WIDTH / _cam.w, SCREEN_HEIGHT / _cam.h)
}

zoom += (zoom_smooth - zoom) * cam_speed
global.cam_x += (cam_x_smooth - global.cam_x) * cam_speed
global.cam_y += (cam_y_smooth - global.cam_y) * cam_speed

var _cam_w = SCREEN_WIDTH / zoom
var _cam_h = SCREEN_HEIGHT / zoom
camera_set_view_pos(view_camera[0], global.cam_x, global.cam_y)
camera_set_view_size(view_camera[0], _cam_w, _cam_h)