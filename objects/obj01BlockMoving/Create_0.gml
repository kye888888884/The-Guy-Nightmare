trg = 0
min_len = 0
max_len = 0
is_triggered = false
t = 0
glow = false
spd = 1

objects = ds_list_create()

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

