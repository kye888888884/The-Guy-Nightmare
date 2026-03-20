update_surface()

draw_surface(surf_bg, 0, 0)

if (keyboard_check(ord("A"))) {
    moon_mat.rotate(0, -1, 0)
}

if (keyboard_check(ord("D"))) {
    moon_mat.rotate(0, 1, 0)
}

if (keyboard_check(ord("W"))) {
    moon_mat.rotate(1, 0, 0)
}

if (keyboard_check(ord("S"))) {
    moon_mat.rotate(-1, 0, 0)
}