index = 0
trg = 0
is_triggered = false
moved = 0
pulley = noone
is_left = false
spd = 1

objects = ds_list_create()

function init() {
}

function add(_ins) {
    ds_list_add(objects, 
        {
            id: _ins, 
            xgap: _ins.x - x, 
            ygap: _ins.y - y,
            anglegap: _ins.image_angle - image_angle
        }
    )
}

function trigger(_trg) {
    if (_trg == trg) {
        is_triggered = true
        return true
    } else
        return false
}

function player_on() {
    var _v = is_left ? 1 : -1
    var _spd = spd * _v
    with (pulley) {
        move(_spd)
    }
}

function stop() {
    with (pulley) {
        move(0)
    }
}