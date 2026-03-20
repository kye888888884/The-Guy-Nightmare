score = 0
goal_score = 15000
completed = false
gameover = false

red_t = 0
red_list = ds_list_create()

depth -= 100

function score_up(_size) {
    if (_size == 0) score += 10
    else if (_size == 1) score += 50
    else if (_size == 2) score += 200
    else if (_size == 3) score += 500
}

surf_line = -1
surf_red = -1

function update_surface() {
    if (!surface_exists(surf_line)) {
        surf_line = surface_create(4, 192)
        surf_red = surface_create(224, 4)
    }

    surface_set_target(surf_line)
    draw_clear_alpha(c_black, 0)
    draw_sprite_tiled(spr01MelonGameLineV, 0, 0, get_time() * 32)
    gpu_set_colorwriteenable(false, false, false, true)
    gpu_set_blendmode_ext(bm_zero, bm_src_color)
    draw_sprite_ext(spr01MelonGameLineV, 1, 0, 0, 1, 6, 0, c_white, 1)
    gpu_set_blendmode(bm_normal)
    gpu_set_colorwriteenable(true, true, true, true)
    surface_reset_target()

    surface_set_target(surf_red)
    draw_clear_alpha(c_black, 0)
    draw_sprite_tiled(spr01MelonGameLineH, 0, get_time() * 32, 0)
    surface_reset_target()
}

current_object_index = choose(0, 1, 2)
create_delay = 0