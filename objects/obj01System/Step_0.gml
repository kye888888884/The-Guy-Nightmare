/// 

var _pipe_mode = pipe_mode
if (!player_on_pipe and pipe_relase_delay <= 0) {
    var _player_meet_pipe = false
    var _pipe = noone
    var _pipe_index = -1
    with (obj01Pipe) {
        if (place_meeting(x, y, objPlayer)) {
            _player_meet_pipe = true
            _pipe = id
            _pipe_index = image_index
            break
        }
    }
    
    if (_player_meet_pipe and _pipe != noone) {
        if (scrButtonCheck(global.upButton) or scrButtonCheck(global.downButton)) {
            player_on_pipe = true
            
            _pipe_mode = (_pipe_index == 0 or _pipe_index >= 4) ? 0 : 1
            // show_debug_message(_pipe_index)
            with (objPlayer) {
                frozen = true
                visible = false
                var _ins = instance_create(obj01PlayerOnPipe, x, y)
                with (_ins) {
                    if (!place_meeting(x, y, obj01Pipe)) {
                        if (_pipe.x > x) {
                            move_contact(obj01Pipe, 0, 8)
                            x += 2
                        }
                        else if (_pipe.x < x) {
                            move_contact(obj01Pipe, 180, 8)
                            x -= 2
                        }

                        if (_pipe.y > y) {
                            move_contact(obj01Pipe, 270, 12)
                            y += 8
                        }
                        else if (_pipe.y < y) {
                            move_contact(obj01Pipe, 90, 12)
                            y -= 4
                        }
                    }
                }
            }
        }
    }
}
pipe_relase_delay = max(pipe_relase_delay - 1, 0)

if (player_on_pipe) {
    var _pipe = noone
    var _pipe_index = -1

    with (obj01Pipe) {
        if (place_meeting(x, y, obj01PlayerOnPipe)) {
            _pipe = id
            _pipe_index = image_index
            if (plant) {
                change_to_plant()
            }
        }
    }

    with (obj01PlayerOnPipe) {
        with (objPlayer) {
            x = other.x
            y = other.y
            vspeed = 0
        }

        if (_pipe != noone) {
                if (scrButtonCheck(global.upButton)) {
                    if (place_meeting(x, y - 2, obj01Pipe)) {
                        if (move_contact(objBlock, 90, 2, 1) < 0)
                            y -= 2
                    }
                }
                else if (scrButtonCheck(global.downButton)) {
                    if (place_meeting(x, y + 2, obj01Pipe)) {
                        if (move_contact(objBlock, 270, 2, 1, 0, 14) < 0)
                            y += 2
                    }
                }
                if (scrButtonCheck(global.leftButton)) {
                    if (place_meeting(x - 2, y, obj01Pipe)) {
                        if (move_contact(objBlock, 180, 2, 1, -4, 0) < 0)
                            x -= 2
                    }
                }
                else if (scrButtonCheck(global.rightButton)) {
                    if (place_meeting(x + 2, y, obj01Pipe)) {
                        if (move_contact(objBlock, 0, 2, 1, 4, 0) < 0)
                            x += 2
                    }
                }
            }

        if (scrButtonCheckPressed(global.jumpButton)) {
            with (objPlayer) {
                djump = true
            }
            instance_destroy()
            other.player_pipe_end()
        }
    }
}
pipe_mode = _pipe_mode