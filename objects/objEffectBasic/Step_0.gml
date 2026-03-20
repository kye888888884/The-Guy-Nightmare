t += 1

image_xscale += xs_spd
image_yscale += ys_spd
xs_spd *= sfric
ys_spd *= sfric

image_blend = merge_color(col1, col2, clamp(t / life, 0, 1))

if (t >= life) {
    image_alpha = max(0, image_alpha - fade_out)
    if (image_alpha == 0) {
        instance_destroy()
    }
}
else {
    image_alpha = min(1, image_alpha + fade_in)
}

coord_on_physics()