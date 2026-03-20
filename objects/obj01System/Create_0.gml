surf_fore = -1
surf_back = -1
surf_light = -1
surf_bg = -1
surf_player = -1
surf_player_mask = -1

player_on_pipe = false
pipe_mode = 0
pipe_relase_delay = 0

physics_world_create(0.05)
physics_world_gravity(0, 40)

gpu_set_tex_repeat(true)

try {
    layer_set_visible(layer_get_id("Background"), false)
}

function player_pipe_end() {
    with (obj01PlayerOnPipe) instance_destroy()
    with (objPlayer) {
        frozen = false
        visible = true
    }
    player_on_pipe = false
    pipe_relase_delay = 10
}

function set_shader(_y, _wave = 0.2, _num = 1, _line = 0.01, _spd = 1, _is_light = false, _x = 0) {
    var _shd = shd01Toxic
    shader_set(_shd)
    shader_set_uniform(_shd, "u_y", _y)
    shader_set_uniform(_shd, "u_wave", _wave)
    shader_set_uniform(_shd, "u_num", _num)
    shader_set_uniform(_shd, "u_line", _line)
    shader_set_uniform(_shd, "u_res", [SCREEN_WIDTH, SCREEN_HEIGHT])
    shader_set_uniform(_shd, "u_pos", [_x, 0])
    shader_set_uniform(_shd, "u_time", get_time() * _spd)
    shader_set_uniform(_shd, "u_is_light", _is_light ? 1 : 0)

    var _tex = sprite_get_texture(sprPerlinString, 0)
    shader_set_texture(_shd, "u_tex_noise", _tex)
}

function draw_wave(_y, _wave = 0.2, _num = 1, _line = 0.01, _spd = 1, _col = c_white, _is_light = false) {
    set_shader(_y, _wave, _num, _line, _spd, _is_light, global.cam_anchor_x)
    draw_sprite_ext(sprRect, 0, 0, 0, SCREEN_WIDTH / 32, SCREEN_HEIGHT / 32, 0, 
    _col, 1)
    shader_reset()
}

function get_x() {
    return global.cam_anchor_x
}

function update_surface() {
    if (!surface_exists(surf_bg)) {
        surf_fore = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
        surf_back = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
        surf_light = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
        surf_bg = surface_create(SCREEN_WIDTH, SCREEN_HEIGHT)
        surf_player = surface_create(32, 32)
        surf_player_mask = surface_create(32, 32)
    }

    surface_set_target(surf_bg)
    draw_sprite_tiled(spr01Bg, 0, -get_x(), 0)
    surface_reset_target()

    surface_set_target(surf_back)
    draw_clear_alpha(c_black, 0)
    shader_set(shd01DistortCyilender)
    draw_surface(surf_bg, 0, 0)
    shader_reset()
    draw_wave(490, 0.05, 4, 0.0, 0.5, make_color_rgb(0, 100, 0), false)
    draw_wave(500, 0.1, 1.5, 0.005, 1, make_color_rgb(0, 150, 0), false)
    surface_reset_target()

    surface_set_target(surf_fore)
    draw_clear_alpha(c_black, 0)
    draw_wave(520, 0.05, 1, 0.01, 1.5)
    surface_reset_target()

    surface_set_target(surf_light)
    draw_clear_alpha(c_black, 0)
    draw_wave(520, 0.05, 1, 0.01, 1.5, c_white, true)
    surface_reset_target()

    surface_set_target(surf_player_mask)
    draw_clear_alpha(c_white, 0)
    if (!player_on_pipe and !instance_exists(obj01GolfPlayer)) {
        with (objPlayer) {
            if (visible)
                draw_sprite_ext(sprite_index, image_index, 17, 22, xScale, image_yscale, 0, image_blend, image_alpha)
        }
    }
    with (obj01PlayerOnPipe) {
        draw_sprite_ext(sprite_index, image_index, 17, 22, image_xscale, image_yscale, 0, c_white, image_alpha)
    }
    with (obj01Handle) {
        if (on_handle) {
            draw_player(16, 15)
        }
    }
    surface_reset_target()

    surface_set_target(surf_player)
    draw_clear_alpha(c_white, 0)
    gpu_set_blendmode_ext(bm_src_alpha, bm_zero)
    gpu_set_colorwriteenable(false, false, false, true)
    draw_surface(surf_player_mask, 0, 0)
    gpu_set_blendmode(bm_normal)
    gpu_set_colorwriteenable(true, true, true, true)
    surface_reset_target()
}