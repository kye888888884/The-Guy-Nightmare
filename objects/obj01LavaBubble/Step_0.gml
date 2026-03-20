if (place_meeting(x, y, objPlayer)) {
    with (objPlayer) {
        scrKillPlayer()
    }
}

if (fired and !fliped and vspeed > -1) {
    fliped = true
}

if (fliped) {
    ys = max(-1, ys - 0.1)
}

t += 1

coord_on_physics()