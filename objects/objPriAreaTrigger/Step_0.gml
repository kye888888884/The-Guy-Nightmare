if (place_meeting(x, y, objPlayer)) {
    with (objPriArea) {
        if (trg == other.trg) touch()
    }
    instance_destroy()
}