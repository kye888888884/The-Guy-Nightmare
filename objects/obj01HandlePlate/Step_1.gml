/// 

if (!on_handle and place_meeting(x, y, objPlayer)) {
    if (scrButtonCheckPressed(global.shootButton)) {
        on_handle = true
        with (objPlayer) {
            frozen = true
        }
        with (obj01PipePlate) {
            if (other.type == LEFT) move_left()
            else move_right()
        }
        handle_delay = 50
    }
}