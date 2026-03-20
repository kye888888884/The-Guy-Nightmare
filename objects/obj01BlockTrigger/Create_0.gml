trg = 0
is_triggered = false
disappear = false
glow = false
moved = 0

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