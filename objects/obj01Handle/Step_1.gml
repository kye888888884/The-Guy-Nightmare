/// 

if (!on_handle and place_meeting(x, y, objPlayer)) {
    if (scrButtonCheckPressed(global.shootButton)) {
        with (objPlayer) { 
            frozen = true
            visible = false 
        }
        on_handle = true
        handle_delay = 10
    }
}