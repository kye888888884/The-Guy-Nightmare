// image_alpha = 0.2

pos = image_index

function update() {
    on_left = pos == 0 or pos == 2 or pos == 3
    on_right = pos == 1 or pos == 3 or pos == 4
}

update()

cleft = {x: 4224, y: 272}
cright = {x: 4416, y: 272}

on_move = false
move_t = 0

cx = x
cy = y
sx = x
sy = y
sangle = 0

function move_left() {
	if (on_left) {
        on_move = true
        sx = x
        sy = y
        cx = cleft.x
        cy = cleft.y
        sangle = image_angle

        var _new_pos = pos
        if (pos == 2) _new_pos = 3
        else if (pos == 3) _new_pos = 2

        with (obj01Pipe) {
            if (plate == other.pos)
                rotate_init(other.cx, other.cy, _new_pos)
        }

        pos = _new_pos
        update()
    }
}

function move_right() {
	if (on_right) {
        on_move = true
        sx = x
        sy = y
        cx = cright.x
        cy = cright.y
        sangle = image_angle

        var _new_pos = pos
        if (pos == 3) _new_pos = 4
        else if (pos == 4) _new_pos = 3

        with (obj01Pipe) {
            if (plate == other.pos)
                rotate_init(other.cx, other.cy, _new_pos)
        }

        pos = _new_pos
        update()
    }
}