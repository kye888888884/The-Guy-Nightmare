//

var nx = phy_col_normal_x
var ny = phy_col_normal_y

col_normal.x = nx
col_normal.y = ny

var _floor_angle = abs(col_normal.dir() - 270)
// show_debug_message("Floor angle: " + string(_floor_angle))
if (_floor_angle > 89) { // on wall
    on_wall = true
}
else if (_floor_angle > FLOOR_MAX_ANGLE) {
    on_sliding = true
}
else { // on floor
    on_floor = true
}