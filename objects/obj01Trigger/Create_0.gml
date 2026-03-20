trg = 0
is_triggered = false
is_active = true
destroy = true
target = objPlayer
t = 0

function trigger(_trg) {
    if (_trg == trg) {
        return true
    } else
        return false
}