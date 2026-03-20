trg = 0
is_triggered = false

sprite_index = spr01Block
image_index = choose(1, 2)
depth = depth - 1

function trigger(_trg) {
    if (_trg == trg) {
        is_triggered = true
        return true
    } else
        return false
}