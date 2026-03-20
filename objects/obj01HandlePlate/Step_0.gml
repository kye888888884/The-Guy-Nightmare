if (on_handle) {
    handle_delay = max(0, handle_delay - 1)
    handle_angle += 540 / 50

    if (handle_delay == 0) {
        on_handle = false
        with (objPlayer) {
            frozen = false
        }
    }
}