if (is_active and !is_triggered and place_meeting(x, y, target)) {
    is_triggered = true
    if (trg == 1) {
        with (obj01BlockFake) {
            if (trigger(1)) {
                var _ins = instance_create(obj01Block, x, y)
                _ins.created = true
                _ins.image_index = image_index
                instance_destroy()
            }
        }
    }
    else if (trg == 2) {
        with (obj01BlockTrigger) {
            if (trigger(2)) gravity = 0.3
            if (trigger(2.2)) disappear = true
        }
        with (obj01Spike) {
            if (trigger(2)) disappear = true
        }
        audio_play_sound(sndCherry, 0, false, 0.5)
    }
    else if (trg == 2.1) {
        with (obj01Trigger) {
            if (trigger(2)) is_active = true
        }
    }
    else if (trg == 3) {
        with (obj01BlockTrigger) { trigger(3) }
        audio_play_sound(sndCherry, 0, false, 0.5)
    }
    else if (trg == 4) {
        with (obj01Trigger) {
            if (trigger(4.1)) is_active = true
        }
    }
    else if (trg == 4.1) {
        with (obj01BlockMoving) {
            if (trigger(1)) ystart = y
        }
        audio_play_sound(sndSpikeTrap, 0, false, 0.5)
    }
    else if (trg == 7) {
        with (objPlayer) {
            frozen = true
            visible = false
            instance_create(obj01GolfPlayer, x, y)
        }
        with (objCamera) {
            set_camera(CAMMODE_SNAP, 1, 1, obj01GolfPlayer)
        }
    }
    else if (trg == 8) {
        with (obj01GolfPlayer) {
            with (objPlayer) {
                frozen = false
                visible = true
                x = other.x
                y = other.y
            }
            ball_visible = false
            window_set_cursor(cr_default)
            window_mouse_set(start_mx, start_my)
        }
        with (objCamera) {
            set_camera(CAMMODE_SNAP, 1, 1, objPlayer)
        }
    }
    else if (trg == 10) {
        with (obj01BlockMoving) {
            if (trigger(10)) ystart = y
            if (trigger(10.1)) {
                xstart = x
                ystart = y
            }
        }
        with (obj01Trigger) {
            if (trigger(11)) is_active = true
        }
    }
    else if (trg == 11) {
        with (obj01BlockMoving) {
            if (trigger(11)) ystart = y
        }
    }
    else if (trg == 11.5) {
        with (obj01Trigger) {
            if (trigger(11.6)) is_active = true
        }
    }
    else if (trg == 11.6) {
        with (obj01SpikeTrap) {
            if (trigger(11.6)) {
                if (vspeed == 0) {
                    vspeed = 4
                    audio_play_sound(sndSpikeTrap, 0, false, 0.5)
                }
            }
        }
    }
    else if (trg == 12) {
        with (obj01BlockMoving) {
            if (trigger(12)) ystart = y
        }
        audio_play_sound(sndSpikeTrap, 0, false, 0.5)
    }
    else if (trg == 13) {
        with (obj01Trigger) {
            if (trigger(12)) is_active = false
        }
    }
    else if (trg == 13.1) {
        with (obj01Trigger) {
            if (trigger(13)) instance_destroy()
        }
    }
    else if (trg == 14) {
        instance_create(obj01MelonGame, 0, 0)
    }
    else if (trg == 17) {
        with (obj01BlockMovingAngular) {
            spd = -1
        }
    }
    else if (trg == 18) {
        with (obj01BlockMovingAngular) {
            spd = 1
        }
    }
    if (destroy)
        instance_destroy()
    show_debug_message("triggered: " + string(trg))
}

if (is_triggered) {
    if (trg == 13) {
        if (t <= 0) {
            t = 40
            if (instance_exists(objPlayer)) {
                instance_create(obj01LavaBubble, floor(objPlayer.x / 32) * 32 + 16, 512)
            }
        }
        t -= 1
    }
}