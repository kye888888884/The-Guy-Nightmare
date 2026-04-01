if (!touched and place_meeting(x, y, objPlayer)) {
    touch()
}

if (touched) {
    t = min(1, t + 1 / 50)
    shd.set_intensity(1 - t)
}