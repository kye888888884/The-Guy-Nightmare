surf_shadow = -1

light_so = new ShaderOption(shdLight)
    .set_uniform("u_light_color", [1.0, 1.0, 1.0])
    .set_uniform("u_dist_min", 160)
    .set_uniform("u_dist_max", 320)

function _draw() {
    // surface_resize(application_surface, SCREEN_WIDTH / 2, SCREEN_HEIGHT / 2)

    if (!surface_exists(surf_shadow)) {
        surf_shadow = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
    }

    surface_set_target(surf_shadow)
    draw_clear_alpha(make_color_hsv(0, 0, 255), 1)
    light_so.set()
    with (objGreLight) {

    }
    light_so.reset()
    surface_reset_target()

    gpu_set_blendmode_ext(bm_dest_color, bm_zero)
    draw_surface(surf_shadow, 0, 0)
    gpu_set_blendmode(bm_normal)
}