trg = 0
is_triggered = false
t = 0
glow = false
spd = 0

prev_x = x
prev_y = y

cx = 5760 + 480
cy = 272
anchor_x = x
anchor_y = y
gap_x = 0
gap_y = 0

sdir = 0
sdis = 192
dir = 0
dis = 0

objects = ds_list_create()

depth -= 10

function init() {
}

function add(_ins) {
    ds_list_add(objects, 
        {
            id: _ins, 
            xgap: _ins.x - x, 
            ygap: _ins.y - y
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

