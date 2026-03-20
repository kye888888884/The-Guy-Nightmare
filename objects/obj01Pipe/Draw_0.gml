if (!plant)
    draw_self()
else {
    if (disappear) image_alpha -= 0.05
    if (image_alpha <= 0) instance_destroy()

    for (var _v = 0; _v < image_yscale; _v++) {
        draw_sprite_ext(sprite_index, 0, x, y + (_v + 0.5 - image_yscale / 2) * 32, 1, 1, 0, c_white, image_alpha)
    }
}