trg = 0
is_triggered = false

depth -= 30

function trigger(_trg) {
    if (!is_triggered and _trg == trg) {
        is_triggered = true
        return true
    } else
        return false
}