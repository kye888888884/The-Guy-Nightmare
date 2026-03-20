if (is_triggered) {
    if (trg == 2) {
        if (y > 440) {
            vspeed = min(1, vspeed)
        }
        else {
            image_angle -= 0.5
        }
        if (y > 680) {
            instance_destroy()
        }
    }
    if (trg == 3) {
        var _spd = 2
        y += min(_spd, 64 - moved)
        moved += _spd
        if (moved >= 64) {
            is_triggered = false
        }
    }
}

if (disappear) {
    image_alpha -= 0.02
    if (image_alpha <= 0) instance_destroy()
}