if (!fired) {
    gpu_set_blendmode(bm_add)
    draw_sprite_ext(spr01LavaBubbleArea, 0, x, ystart - 32, 1, 1, 0, c_white, t / 25)
    gpu_set_blendmode(bm_normal)
}

image_xscale = 1.8 * (0.85 + 0.15 * sin(get_time() * 10))
image_yscale = 1.8 * ys * (0.85 + 0.15 * sin(get_time() * 10))

draw_self()