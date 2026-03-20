if (is_triggered) {
    if (trg == 1) {
        t = min(1, t + 0.1)
        y = ystart + 32 * curve_value(ac01, "trg1", t)
    }
    else if (trg == 10) {
        t = min(1, t + 0.1)
        y = ystart - 64 * t
    }
    else if (trg == 10.1) {
        t = min(1, t + 0.1)
        x = xstart - 32 * t
        y = ystart + 56 * t
    }
    else if (trg == 11) {
        t = min(1, t + 0.1)
        y = ystart - 32 * t
    }
    else if (trg == 12) {
        t = min(1, t + 0.1)
        y = ystart + 64 * curve_value(ac01, "trg1", t)
    }
}