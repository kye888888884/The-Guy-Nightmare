t = 0
dist = 0

function create_map(_p) {
    for (var _dist = 0; _dist < _p.len();) {
        var _pos = _p.get_pos_dist(_dist)
        var _ins = instance_create(objPriBlock, x + _pos.x, y + _pos.y, 1.05, 0.5)
        _ins.image_angle = _p.get_dir_dist(_dist, 16).dir()
        _dist += 32
    }
}

function step() {
    t += 1
    if (t >= 35) {
        t = 0
        with (instance_create(objPriSpikeFollowCurve, x, y, 0, 0)) {
            init(other.path1, 0, 0)
        }
        with (instance_create(objPriSpikeFollowCurve, x, y, 0, 0)) {
            init(other.path2, 180, 0)
        }
    }
}

function draw() {
    // var _add = 0
    // if (WHEEL_UP) _add = 1
    // else if (WHEEL_DOWN) _add = -1
    // dist += _add * 16
    // var dist1 = clamp(dist, 0, path1.len())
    // var dist2 = clamp(dist, 0, path2.len())

    // draw_circle_color(x + path1.get_pos_dist(dist1).x, y + path1.get_pos_dist(dist1).y, 4, c_red, c_red, false)
    // draw_circle_color(x + path2.get_pos_dist(dist2).x, y + path2.get_pos_dist(dist2).y, 4, c_blue, c_blue, false)
}

function debug() {
    draw_text_outline("Dist: " + string(dist), 10, 90)
}

path1 = new Path(pathPriCurve1)
path2 = new Path(pathPriCurve1_2)
create_map(path1)
create_map(path2)