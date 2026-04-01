if (place_meeting(x, y, objPlayer)) {
    on_move = true
}

if (on_move) {
    x += 5
    y -= 1
    with (objPlayer) {
        fix_move(other.x + 36, other.y - 74)
    }

    spin += 5.78
}