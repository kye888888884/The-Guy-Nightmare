dist = 0
dist_offset = 0
max_dist = 0
spd = 3
path = noone
angle_offset = 0
active = true

prev_pos = noone
next_pos = noone
prev_dir = 0
next_dir = 0

show = 0

alarm[0] = irandom_range(1, 100)

function init(_path, _angle_offset = 0, _dist_offset = 0) {
    path = _path
    angle_offset = _angle_offset
    dist_offset = _dist_offset
    max_dist = path.len()
    show = 1
    prev_pos = path.get_pos_dist(0)
    next_pos = path.get_pos_dist(32)
    prev_dir = path.get_dir_dist(0).dir() + angle_offset
    next_dir = path.get_dir_dist(32).dir() + angle_offset
}

function step() {
    dist += spd
    if (dist > 32) {
        dist_offset += 32
        dist -= 32
        if (active) {
            var _next_dist = clamp(dist_offset + 32, 0, max_dist - 16)
            prev_pos = next_pos
            next_pos = path.get_pos_dist(_next_dist)
            prev_dir = next_dir
            next_dir = path.get_dir_dist(_next_dist).dir() + angle_offset
            if (abs(next_dir - prev_dir) > 180) {
                if (next_dir > prev_dir) next_dir -= 360
                else next_dir += 360
            }
        }
    }
    if (active) {
        var _pos = prev_pos.lerp(next_pos, dist / 32)
        x = xstart + _pos.x
        y = ystart + _pos.y
        image_angle = lerp(prev_dir, next_dir, dist / 32)
    }

    var _dist = dist_offset + dist
    if (angle_offset == 0) {
        if (_dist < 3120)
            spd = 3
        else if (_dist < 4468)
            spd = 0.75
        else if (_dist < 7328)
            spd = 6
        else
            spd = 3
    }

    else {
        if (_dist < 3248)
            spd = 3
        else if (_dist < 3940)
            spd = 0.75
        else if (_dist < 7264)
            spd = 6
        else
            spd = 3
    }

    if (_dist >= max_dist) {
        spd = 0
        show = -1
    }

    image_xscale = clamp(image_xscale + 0.05 * show, 0, 1)
    image_yscale = image_xscale

    if (show < 0 and image_xscale <= 0) {
        instance_destroy()
    }
}

function draw_front() {
    if (active) {
        image_index = 1
        draw_self()
    }
}

function draw_back() {
    if (active) {
        image_index = 0
        draw_self()
    }
}

function update() {
    var _chunk = global.current_chunk
    var _left = (_chunk.x - 1) * global.chunk_size
    var _top = (_chunk.y - 1) * global.chunk_size
    var _w = global.chunk_size * 4
    var _h = global.chunk_size * 4
    var _in_box = point_in_rectangle(x, y, _left, _top, _left + _w, _top + _h)
    if (!_in_box) {
        active = false
    }
    else {
        active = true
    }
}