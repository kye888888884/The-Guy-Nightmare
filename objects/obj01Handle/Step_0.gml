if (on_handle) {
    handle_delay = max(0, handle_delay - 1)
    if (scrButtonCheck(global.leftButton)) {
        move(spin_spd)
    }
    else if (scrButtonCheck(global.rightButton)) {
        move(-spin_spd)
    }

    if (handle_delay == 0 and scrButtonCheckPressed(global.shootButton)) {
        with (objPlayer) { 
            frozen = false
            visible = true
        }
        on_handle = false
    }
}