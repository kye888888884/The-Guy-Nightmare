left = noone
right = noone
up_empty = 0

depth -= 5

left_index = -1
right_index = -1

function move(_spd = 0) {
    var _can_move = true
    if (_spd != 0) {
        with (left) {
            if (y + _spd <= other.y + 16 or place_meeting(x, y + _spd, objBlock)) {
                _can_move = false
            }
        }
        with (right) {
            if (y - _spd <= other.y + 16 or place_meeting(x, y - _spd, objBlock)) {
                _can_move = false
            }
        }
    }

    if (_can_move) {
        with (left) {
            vspeed = _spd
        }
        with (right) {
            vspeed = -_spd
        }
    }
}